############################################################
# ECS Fargate Service Resource
############################################################
resource "aws_ecs_service" "ecs_fargate_service" {
  name            = "${var.name}-fargate-${var.environment}"
  cluster         = var.cluster_id
  task_definition = var.task_definition
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip != null ? var.assign_public_ip : false
  }
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  enable_execute_command             = true
  lifecycle {
    ignore_changes = [task_definition]
  }
}