output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "private_route_table_ids" {
  description = "IDs of private route tables"
  value       = aws_route_table.private.*.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway (null if disabled)"
  value       = lookup(aws_internet_gateway.igw, "igw", null) != null ? aws_internet_gateway.igw["igw"].id : null
}

output "public_route_table_id" {
  description = "The ID of the Public Route Table (null if disabled)"
  value       = lookup(aws_route_table.public, "public", null) != null ? aws_route_table.public["public"].id : null
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}