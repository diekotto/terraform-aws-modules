output "repository" {
  description = "The ECR repository resource"
  value       = aws_ecr_repository.this
}

output "lifecycle_policy" {
  description = "The ECR lifecycle policy resource"
  value       = var.lifecycle_policy_enabled ? aws_ecr_lifecycle_policy.this[0] : null
}

output "repository_policy" {
  description = "The ECR repository policy resource"
  value       = var.repository_policy_enabled ? aws_ecr_repository_policy.this[0] : null
}
