output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "http_listener_arn" {
  value = length(aws_lb_listener.http) > 0 ? aws_lb_listener.http[0].arn : null
}

output "https_listener_arn" {
  value = length(aws_lb_listener.https) > 0 ? aws_lb_listener.https[0].arn : null
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}