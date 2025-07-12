output "ecr_dkr_endpoint_id" {
  value = aws_vpc_endpoint.this["ecr_dkr"].id
}

output "ecr_api_endpoint_id" {
  value = aws_vpc_endpoint.this["ecr_api"].id
}

output "logs_endpoint_id" {
  value = aws_vpc_endpoint.this["logs"].id
}

output "vpc_endpoint_ids" {
  value = {
    for k, ep in aws_vpc_endpoint.this : k => ep.id
  }
}
