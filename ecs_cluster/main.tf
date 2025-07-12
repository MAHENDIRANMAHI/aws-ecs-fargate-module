############################################################
# ECS Cluster Resource
############################################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}-cluster-${var.environment}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = var.managed_by
  }
}