# terraform-aws-modules

Reusable, opinionated Terraform modules for common AWS infrastructure patterns. Built to provide secure defaults and reduce boilerplate across projects.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.0 |
| AWS Provider | >= 5.0 |

## Modules

| Module | Description |
|--------|-------------|
| [s3](modules/s3) | S3 bucket with encryption, public access block, versioning, and lifecycle rules |
| [ecr](modules/ecr) | ECR repository with image scanning, lifecycle policy, and repository policies |
| [ecs](modules/ecs) | ECS Fargate service with task definition, IAM roles, logging, and LB integration |
| [alb](modules/alb) | Application Load Balancer with security group, target group, and HTTP/HTTPS listeners |
| [nlb](modules/nlb) | Network Load Balancer with target group and TCP/UDP/TLS listener |

## Usage

Reference modules from this repo using a Git source:

```hcl
module "my_bucket" {
  source = "git::https://github.com/diekotto/terraform-aws-modules.git//modules/s3?ref=main"

  bucket_name = "my-app-assets"
}
```

Pin to a specific tag for stability:

```hcl
module "my_service" {
  source = "git::https://github.com/diekotto/terraform-aws-modules.git//modules/ecs?ref=v1.0.0"

  service_name = "my-api"
  image_uri    = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-api:latest"
  vpc_id       = "vpc-abc123"
  subnet_ids   = ["subnet-aaa", "subnet-bbb"]
}
```

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.

## License

[MIT](LICENSE) - Diego Maroto
