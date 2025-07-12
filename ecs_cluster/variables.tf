variable "name" {
  description = "Name for the ECS cluster."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ECS cluster."
  type        = string
}

variable "environment" {
  description = "Environment for the ECS cluster (e.g., dev, stage, prod)."
  type        = string
}

variable "project" {
  description = "Project name for tagging resources."
  type        = string
}

variable "managed_by" {
  description = "Indicates who manages the resource."
  type        = string
  default     = "Terraform"
}

variable "cluster_name" {
  description = "Unique name for the ECS cluster (e.g., analytics, app, etc.)."
  type        = string
}