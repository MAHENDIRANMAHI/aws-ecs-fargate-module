# module "vpc" {
#   source          = "../modules/vpc"
#   name            = "ecs-vpc"
#   cidr_block      = "10.0.0.0/16"
#   public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
#   private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
# }

# Use default VPC and subnets

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

data "aws_availability_zones" "available" {}

locals {
  # Map subnet ID to its AZ
  subnet_az_map = { for s in data.aws_subnets.default.ids :
    s => data.aws_subnet.selected[s].availability_zone
  }
  # Get unique AZs
  unique_azs = distinct(values(local.subnet_az_map))
  # Select one subnet per AZ (up to 2)
  selected_subnets = [for az in slice(local.unique_azs, 0, 2) :
    [for s, az_name in local.subnet_az_map : s if az_name == az][0]
  ]
}

module "ecr" {
  source = "../modules/ecr"
  name   = "ecs-app-repo"
}

module "ecs_cluster" {
  source = "../modules/ecs_cluster"
  name   = "ecs-fargate-cluster"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg"
  vpc_id      = data.aws_vpc.default.id
  description = "Allow inbound from ALB only"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = local.selected_subnets
  security_groups    = [aws_security_group.ecs_service.id]
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

module "ecs_task_definition" {
  source         = "../modules/ecs_task_definition"
  family         = "ecs-fargate-app"
  container_name = "app"
  image          = "nginx:latest" #module.ecr.repository_url
  container_port = 80
  cpu            = 256
  memory         = 512
}

module "ecs_fargate_service" {
  source               = "../modules/ecs_fargate_service"
  name                 = "ecs-fargate-service"
  cluster_id           = module.ecs_cluster.ecs_cluster_id
  task_definition      = module.ecs_task_definition.task_definition_arn
  desired_count        = 2
  subnet_ids           = local.selected_subnets
  security_group_ids   = [aws_security_group.ecs_service.id]
  alb_target_group_arn = aws_lb_target_group.ecs_tg.arn
  container_name       = "app"
  container_port       = 80
  cpu                  = 256
  memory               = 512
  autoscaling_max      = 4
  autoscaling_min      = 1
}
