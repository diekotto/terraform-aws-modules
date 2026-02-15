# ecr

Creates an ECR repository with image scanning on push and an optional lifecycle policy to limit stored images. Includes a default ECS pull repository policy when no custom policy is provided.

## Resources

- `aws_ecr_repository`
- `aws_ecr_lifecycle_policy` (optional)
- `aws_ecr_repository_policy` (optional, defaults to ECS pull policy)

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `repository_name` | `string` | *required* | The name of the ECR repository |
| `image_tag_mutability` | `string` | `"IMMUTABLE"` | Tag mutability (`MUTABLE` or `IMMUTABLE`) |
| `scan_on_push` | `bool` | `true` | Enable image scanning on push |
| `lifecycle_policy_enabled` | `bool` | `true` | Enable lifecycle policy |
| `max_image_count` | `number` | `10` | Max images to keep |
| `repository_policy_enabled` | `bool` | `false` | Attach a repository policy |
| `repository_policy` | `string` | `null` | Custom policy JSON (defaults to ECS pull policy if null) |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|------|-------------|
| `repository` | The `aws_ecr_repository` resource |
| `lifecycle_policy` | The lifecycle policy resource (or `null`) |
| `repository_policy` | The repository policy resource (or `null`) |

## Example

```hcl
module "api_repo" {
  source = "git::https://github.com/diekotto/terraform-aws-modules.git//modules/ecr?ref=main"

  repository_name   = "my-api"
  max_image_count   = 20
}
```
