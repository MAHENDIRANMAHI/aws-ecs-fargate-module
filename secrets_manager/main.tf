############################################################
# Secrets Manager Module - Reusable for Any Secret
############################################################

# Generates a password only if enabled via variable
resource "random_password" "this" {
  count   = var.generate_random_password ? 1 : 0
  length  = var.random_password_length
  special = true
  override_special   = "!#$%^&*()-_=+[]{}|:,.<>?"
}

############################################################
# Secrets Manager Secret Resource
############################################################
resource "aws_secretsmanager_secret" "this" {
  name        = "${var.name}-secret-${var.environment}"
  description = var.description
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

############################################################
# Secrets Manager Secret Version Resource
############################################################
resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = lookup(var.secret_kv, "username", "")
    password = lookup(var.secret_kv, "password", "")
    # ...add other keys as needed, using lookup(var.secret_kv, "key", "")
  })
}