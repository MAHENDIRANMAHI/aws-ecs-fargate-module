variable "family" {
  description = "The family of the ECS task definition."
  type        = string
}

variable "container_name" {
  description = "Name of the container."
  type        = string
}

variable "image" {
  description = "Container image URI."
  type        = string
}

variable "container_port" {
  description = "Port the container exposes."
  type        = number
}

variable "cpu" {
  description = "CPU units for the task."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (MB) for the task."
  type        = number
  default     = 512
}

variable "tags" {
  description = "Map of tags to apply to the ECS task definition."
  type        = map(string)
  default     = {}
}

variable "secret_arn" {
  description = "ARN of the secret in AWS Secrets Manager to pass to the container."
  type        = string
  default     = null
}
variable "environment" {
  description = "Environment for the ECS task definition (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "execution_role_name" {
  type    = string
  default = null
}

variable "task_role_name" {
  type    = string
  default = null
}

variable "enable_logging" {
  description = "Enable CloudWatch logging"
  type        = bool
  default     = false
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
  default     = null
}

variable "enable_cloudwatch_logging" {
  type    = bool
  default = false
}

variable "region" {
  type = string
}

variable "log_group_retention_in_days" {
  type    = number
  default = 14
}

variable "secrets_list" {
  description = "Optional list of secrets to inject into the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "override_task_role_arn" {
  description = "Use external task role if provided"
  type        = string
  default     = null
}

variable "override_execution_role_arn" {
  description = "Use external execution role if provided"
  type        = string
  default     = null
}