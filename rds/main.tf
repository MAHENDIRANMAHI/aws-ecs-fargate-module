############################################################
# RDS Subnet Group
############################################################
resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.name}-subnet_group-${var.environment}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

############################################################
# RDS Database Instance
############################################################
resource "aws_db_instance" "rds_instance" {
  identifier              = "${var.name}-rds-${var.environment}"
  engine                  = var.engine
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.use_secrets_manager ? jsondecode(data.aws_secretsmanager_secret_version.db_creds[0].secret_string)["username"] : var.username
  password                = var.use_secrets_manager ? jsondecode(data.aws_secretsmanager_secret_version.db_creds[0].secret_string)["password"] : var.password
  port                    = var.engine == "postgres" ? 5432 : 3306
  publicly_accessible     = false
  vpc_security_group_ids  = [var.security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot     = true
  deletion_protection     = false
  multi_az                = false

  tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

data "aws_secretsmanager_secret_version" "db_creds" {
  count       = var.use_secrets_manager ? 1 : 0
  secret_id   = var.db_credentials_secret_name
}
