variable "name" {
  description = "Name for the ECS Fargate service."
  type        = string
}

variable "cluster_id" {
  description = "ECS cluster ID."
  type        = string
}

variable "task_definition" {
  description = "Task definition ARN."
  type        = string
}

variable "desired_count" {
  description = "Desired number of ECS tasks."
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs for the service."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the service."
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB target group."
  type        = string
}

variable "container_name" {
  description = "Name of the container to associate with the ALB."
  type        = string
}

variable "container_port" {
  description = "Port on the container to associate with the ALB."
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

variable "autoscaling_max" {
  description = "Maximum number of tasks for autoscaling."
  type        = number
  default     = 2
}

variable "autoscaling_min" {
  description = "Minimum number of tasks for autoscaling."
  type        = number
  default     = 1
}
