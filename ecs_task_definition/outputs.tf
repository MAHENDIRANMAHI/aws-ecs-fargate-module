output "task_definition_arn" {
  description = "The ARN of the ECS task definition."
  value       = aws_ecs_task_definition.ecs_task_definition.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CW log group (if created)"
  value = length(aws_cloudwatch_log_group.this) > 0 ? aws_cloudwatch_log_group.this[0].name : null
}

output "task_role_arn" {
  value = var.override_task_role_arn != null ? var.override_task_role_arn : aws_iam_role.ecs_task_role.arn
}
# output "task_role_name" {
#   value = aws_iam_role.ecs_task_role.name
# }

# output "task_role_arn" {
#   value = aws_iam_role.ecs_task_role.arn
# }

output "task_role_name" {
  value = var.override_task_role_arn != null ? element(split("/", var.override_task_role_arn), length(split("/", var.override_task_role_arn)) - 1) : aws_iam_role.ecs_task_role.name
}

