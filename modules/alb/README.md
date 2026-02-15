# alb

Creates an Application Load Balancer with a security group (HTTP/HTTPS ingress), an IP-based target group, and listeners. When a `certificate_arn` is provided, it creates both an HTTPS listener and an HTTP-to-HTTPS redirect; otherwise it creates an HTTP-only listener.

## Resources

- `aws_lb` (application)
- `aws_lb_target_group` (IP target type)
- `aws_lb_listener` (HTTP redirect + HTTPS, or HTTP-only)
- `aws_security_group` (ports 80/443 ingress, all egress)

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | *required* | Name of the load balancer |
| `vpc_id` | `string` | *required* | VPC ID |
| `subnet_ids` | `list(string)` | *required* | Subnets (must be in different AZs) |
| `internal` | `bool` | `false` | Internal or internet-facing |
| `enable_deletion_protection` | `bool` | `false` | Enable deletion protection |
| `ingress_cidr_blocks` | `list(string)` | `["0.0.0.0/0"]` | CIDRs allowed on ports 80/443 |
| `target_port` | `number` | `80` | Target port |
| `target_protocol` | `string` | `"HTTP"` | Target protocol (`HTTP` or `HTTPS`) |
| `certificate_arn` | `string` | `null` | ACM certificate ARN for HTTPS |
| `ssl_policy` | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | SSL policy |
| `health_check_path` | `string` | `"/"` | Health check path |
| `health_check_healthy_threshold` | `number` | `2` | Healthy threshold |
| `health_check_unhealthy_threshold` | `number` | `2` | Unhealthy threshold |
| `health_check_timeout` | `number` | `5` | Health check timeout (seconds) |
| `health_check_interval` | `number` | `30` | Health check interval (seconds) |
| `health_check_matcher` | `string` | `"200"` | Expected HTTP response codes |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|------|-------------|
| `load_balancer` | The `aws_lb` resource |
| `target_group` | The target group resource |
| `security_group` | The ALB security group resource |

## Example

```hcl
module "api_alb" {
  source = "git::https://github.com/diekotto/terraform-aws-modules.git//modules/alb?ref=main"

  name            = "my-api"
  vpc_id          = "vpc-abc123"
  subnet_ids      = ["subnet-aaa", "subnet-bbb"]
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
  target_port     = 8080

  health_check_path = "/health"
}
```
