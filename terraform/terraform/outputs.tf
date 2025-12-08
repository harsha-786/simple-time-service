
output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.this.dns_name
}

output "service_url" {
  description = "HTTP URL for the service"
  value       = "http://${aws_lb.this.dns_name}/"
}
