variable "name" {
  description = "Identifier and base name for the RDS resources"
  type        = string
}

variable "engine" {
  description = "The database engine to use (mysql, postgres)"
  type        = string
}

variable "instance_class" {
  description = "RDS instance type (e.g., db.t4g.micro)"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "The size of DB (in GB)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the initial DB"
  type        = string
}

variable "username" {
  description = "Master DB username (optional if using Secrets Manager)"
  type        = string
  sensitive   = true
  default     = null
}

variable "password" {
  description = "Master DB password (optional if using Secrets Manager)"
  type        = string
  sensitive   = true
  default     = null
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the DB instance"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, stage, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "use_secrets_manager" {
  description = "Whether to use AWS Secrets Manager for DB credentials"
  type        = bool
  default     = false
}

variable "db_credentials_secret_name" {
  description = "Name of the Secrets Manager secret storing DB credentials"
  type        = string
  default     = null
}
