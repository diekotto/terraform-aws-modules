# nlb

Creates a Network Load Balancer with an IP-based target group and a single listener. Supports TCP, UDP, TCP_UDP, and TLS protocols. TLS termination is handled automatically when `listener_protocol` is set to `TLS`.

## Resources

- `aws_lb` (network)
- `aws_lb_target_group` (IP target type)
- `aws_lb_listener`

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | *required* | Name of the load balancer |
| `vpc_id` | `string` | *required* | VPC ID |
| `subnet_ids` | `list(string)` | *required* | Subnets (must be in different AZs) |
| `internal` | `bool` | `false` | Internal or internet-facing |
| `enable_deletion_protection` | `bool` | `false` | Enable deletion protection |
| `target_port` | `number` | `80` | Target port |
| `target_protocol` | `string` | `"TCP"` | Target protocol (`TCP`, `UDP`, `TCP_UDP`, `TLS`) |
| `listener_port` | `number` | `80` | Listener port |
| `listener_protocol` | `string` | `"TCP"` | Listener protocol |
| `certificate_arn` | `string` | `null` | Certificate ARN for TLS listeners |
| `health_check_enabled` | `bool` | `true` | Enable health checks |
| `health_check_healthy_threshold` | `number` | `3` | Healthy threshold |
| `health_check_unhealthy_threshold` | `number` | `3` | Unhealthy threshold |
| `health_check_interval` | `number` | `30` | Health check interval (seconds) |
| `health_check_port` | `string` | `"traffic-port"` | Health check port |
| `health_check_protocol` | `string` | `"TCP"` | Health check protocol (`TCP`, `HTTP`, `HTTPS`) |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|------|-------------|
| `load_balancer` | The `aws_lb` resource |
| `target_group` | The target group resource |
| `listener` | The listener resource |

## Example

```hcl
module "grpc_nlb" {
  source = "git::https://github.com/diekotto/terraform-aws-modules.git//modules/nlb?ref=main"

  name       = "my-grpc-service"
  vpc_id     = "vpc-abc123"
  subnet_ids = ["subnet-aaa", "subnet-bbb"]

  target_port       = 50051
  listener_port     = 50051
  target_protocol   = "TCP"
  listener_protocol = "TCP"
}
```
