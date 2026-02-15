output "load_balancer" {
  description = "The network load balancer resource"
  value       = aws_lb.this
}

output "target_group" {
  description = "The target group resource"
  value       = aws_lb_target_group.this
}

output "listener" {
  description = "The load balancer listener resource"
  value       = aws_lb_listener.this
}