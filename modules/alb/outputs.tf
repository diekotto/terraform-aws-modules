output "load_balancer" {
  description = "The load balancer resource"
  value       = aws_lb.this
}

output "target_group" {
  description = "The target group resource"
  value       = aws_lb_target_group.this
}

output "security_group" {
  description = "The security group resource for the load balancer"
  value       = aws_security_group.alb
}