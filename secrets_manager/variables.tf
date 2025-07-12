variable "name" {
  description = "DRY name for the secret, e.g. var.name-var.environment."
  type        = string
}

variable "description" {
  description = "Description for the secret."
  type        = string
}

variable "secret_kv" {
  description = "Key-value map for the secret contents."
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (e.g., stage, prod)."
  type        = string
}

variable "project" {
  description = "Project name."
  type        = string
}

variable "generate_random_password" {
  description = "Set to true if you want to auto-generate the password"
  type        = bool
  default     = false
}

variable "random_password_length" {
  type        = number
  description = "Length of generated password"
  default     = 16

  validation {
    condition     = var.random_password_length >= 8
    error_message = "Password length must be at least 8 characters for RDS."
  }
}
