variable "alb_name" {
  description = "The name of the Application Load Balancer."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs where the ALB will be deployed."
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs to associate with the ALB."
  type        = list(string)
}

variable "internal" {
  description = "Boolean flag to set the ALB as internal or internet-facing."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the ALB."
  type        = map(string)
  default     = {}
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener"
  type        = string
  default     = ""
}

variable "enable_http" {
  description = "Whether to enable HTTP listener"
  type        = bool
  default     = true
}