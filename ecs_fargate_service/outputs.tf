output "service_name" {
  value = aws_ecs_service.ecs_fargate_service.name
}

output "service_arn" {
  value = aws_ecs_service.ecs_fargate_service.arn
}

output "task_definition" {
  value = aws_ecs_service.ecs_fargate_service.task_definition
}