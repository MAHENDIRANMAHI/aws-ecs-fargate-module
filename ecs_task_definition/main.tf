
############################################################
# ECS Task Definition module for Fargate
############################################################

############################################################
# IAM Role for ECS Task Execution
############################################################
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.family}-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  tags = var.tags
}

############################################################
# IAM Policy Document for ECS Task Assume Role
############################################################
data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

############################################################
# Attach Execution Policy to ECS Task Execution Role
############################################################
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############################################################
# IAM Role for ECS Task
############################################################
resource "aws_iam_role" "ecs_task_role" {
   name = "${var.family}-task-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
   tags = var.tags
}

############################################################
# Attach Policy to ECS Task Role
############################################################
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# locals {
#   logging = var.enable_cloudwatch_logging && var.log_group_name != null ? {
#     logConfiguration = {
#       logDriver = "awslogs"
#       options = {
#         awslogs-group         = var.log_group_name
#         awslogs-region        = var.region
#         awslogs-stream-prefix = var.container_name
#         awslogs-create-group  = "true"
#       }
#     }
#   } : {}
  
#   container_defs = [
#     merge(
#       {
#         name         = var.container_name
#         image        = var.image
#         essential    = true
#         portMappings = [{ containerPort = var.container_port, hostPort = var.container_port }]
#         environment  = var.secret_arn != null ? [
#           { name = "DB_USERNAME", valueFrom = { secretsManagerSecretId = var.secret_arn, jsonField = "username" } },
#           { name = "DB_PASSWORD", valueFrom = { secretsManagerSecretId = var.secret_arn, jsonField = "password" } }
#         ] : []
#       },
#       local.logging
#     )
#   ]
# }

locals {
  container_defs = [
    merge(
      {
        name         = var.container_name
        image        = var.image
        essential    = true
        portMappings = [{ containerPort = var.container_port, hostPort = var.container_port }]
        
      },
      // Add secrets block only if secrets_list is not empty
      length(var.secrets_list) > 0 ? {
        secrets = var.secrets_list
      } : {},
      // Add logging config only if logging is enabled
      var.enable_cloudwatch_logging && var.log_group_name != null ? {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.log_group_name
            awslogs-region        = var.region
            awslogs-stream-prefix = var.container_name
            awslogs-create-group  = "true"
          }
        }
      } : {}
    )
  ]
}

############################################################
# ECS Task Definition Resource
############################################################
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn = var.override_execution_role_arn != null ? var.override_execution_role_arn : aws_iam_role.ecs_task_execution.arn
  task_role_arn      = var.override_task_role_arn != null ? var.override_task_role_arn : aws_iam_role.ecs_task_role.arn
  container_definitions    = jsonencode(local.container_defs)
  tags                     = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_cloudwatch_logging && var.log_group_name != null ? 1 : 0
  name              = var.log_group_name
  retention_in_days = var.log_group_retention_in_days
  tags              = var.tags
}


