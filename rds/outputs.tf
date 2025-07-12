output "rds_endpoint" {
  value       = aws_db_instance.rds_instance.endpoint
  description = "The RDS database endpoint"
}

output "rds_port" {
  value       = aws_db_instance.rds_instance.port
  description = "The port the RDS database is listening on"
}

output "rds_identifier" {
  value       = aws_db_instance.rds_instance.id
  description = "The ID of the RDS instance"
}

output "rds_subnet_group" {
  value       = aws_db_subnet_group.subnet_group.name
  description = "The name of the RDS subnet group"
}

output "rds_sg_id" {
  description = "RDS SG ID passed to the module"
  value       = var.security_group_id
}


