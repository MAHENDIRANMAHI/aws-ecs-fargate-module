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
