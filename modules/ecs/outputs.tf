output "cluster" {
  description = "The ECS cluster resource (null if using an existing cluster)"
  value       = var.cluster_arn == null ? aws_ecs_cluster.this[0] : null
}

output "service" {
  description = "The ECS service resource"
  value       = aws_ecs_service.this
}

output "task_definition" {
  description = "The ECS task definition resource"
  value       = aws_ecs_task_definition.this
}

output "security_group" {
  description = "The security group resource"
  value       = aws_security_group.this
}

output "log_group" {
  description = "The CloudWatch log group resource"
  value       = aws_cloudwatch_log_group.this
}

output "task_execution_role" {
  description = "The IAM role resource for task execution"
  value       = aws_iam_role.task_execution
}
