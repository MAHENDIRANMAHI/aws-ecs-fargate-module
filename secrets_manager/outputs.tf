output "secret_arn" {
  description = "The ARN of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_id" {
  description = "The ID of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_name" {
  description = "The name of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.name
}

output "secret_value" {
  description = "Decoded secret value"
  value       = aws_secretsmanager_secret_version.this.secret_string
  sensitive   = true
}