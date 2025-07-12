variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to associate with the endpoints"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs to attach to the endpoints"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the endpoints"
  type        = map(string)
  default     = {}
}

variable "endpoints" {
  type = map(object({
    service_name        = string
    private_dns_enabled = optional(bool)
    vpc_endpoint_type   = optional(string) # Default is Interface
    route_table_ids     = optional(list(string)) # Only needed for Gateway
  }))
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Route table IDs to associate gateway endpoints with"
  default     = []
}

output "s3_endpoint_id" {
  value = aws_vpc_endpoint.this["s3"].id
}