############################################################
# Input Variables for ECR Module
############################################################

variable "project" {
  description = "Project name prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., stage, prod) for resource naming."
  type        = string
}

variable "name" {
  description = "Name for the ECR repository."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the ECR repository."
  type        = map(string)
  default     = {}
}
