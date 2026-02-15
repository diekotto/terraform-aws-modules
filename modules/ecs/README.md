# ecs

Creates a complete ECS Fargate service: task definition, execution IAM role, security group, CloudWatch log group, and optional ECS cluster. Supports load balancer integration via target group attachment.

Container definitions use `ignore_changes` on `container_definitions` so that image deployments via CI/CD don't cause drift.

## Resources

- `aws_ecs_cluster` (optional, created when `cluster_arn` is null)
- `aws_ecs_task_definition` (Fargate, awsvpc)
- `aws_ecs_service`
- `aws_iam_role` + `aws_iam_role_policy_attachment` (task execution role)
- `aws_security_group` with ingress/egress rules
- `aws_cloudwatch_log_group`

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `service_name` | `string` | *required* | The name of the ECS service |
| `image_uri` | `string` | *required* | Docker image URI to deploy |
| `vpc_id` | `string` | *required* | VPC ID for the service |
| `subnet_ids` | `list(string)` | *required* | Subnets for the service |
| `container_port` | `number` | `80` | Port the container listens on |
| `cpu` | `number` | `256` | CPU units for the task |
| `memory` | `number` | `512` | Memory (MiB) for the task |
| `desired_count` | `number` | `1` | Number of task instances |
| `assign_public_ip` | `bool` | `true` | Assign public IP to the task ENI |
| `environment_variables` | `map(string)` | `{}` | Env vars passed to the container |
| `health_check` | `object` | `null` | Container health check config |
| `cluster_arn` | `string` | `null` | Existing cluster ARN (creates one if null) |
| `log_retention_days` | `number` | `14` | CloudWatch log retention |
| `enable_load_balancer` | `bool` | `false` | Enable LB integration |
| `target_group_arn` | `string` | `null` | Target group ARN (required if LB enabled) |
| `load_balancer_security_group_id` | `string` | `null` | LB security group for ingress rules |
| `allow_anywhere_access` | `bool` | `false` | Allow 0.0.0.0/0 access when no LB |
| `task_role_arn` | `string` | `null` | IAM role for the application container |
| `architecture` | `string` | `"ARM64"` | CPU architecture (`X86_64` or `ARM64`) |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|------|-------------|
| `cluster` | The ECS cluster resource (or `null` if using existing) |
| `service` | The ECS service resource |
| `task_definition` | The task definition resource |
| `security_group` | The service security group |
| `log_group` | The CloudWatch log group |
| `task_execution_role` | The task execution IAM role |

## Example

```hcl
module "api_service" {
  source = "git::https://github.com/diekotto/terraform-aws-modules.git//modules/ecs?ref=main"

  service_name   = "my-api"
  image_uri      = module.api_repo.repository.repository_url
  vpc_id         = "vpc-abc123"
  subnet_ids     = ["subnet-aaa", "subnet-bbb"]
  container_port = 8080
  cpu            = 512
  memory         = 1024

  enable_load_balancer             = true
  target_group_arn                 = module.api_alb.target_group.arn
  load_balancer_security_group_id  = module.api_alb.security_group.id

  environment_variables = {
    NODE_ENV = "production"
  }
}
```
