# s3

Creates an S3 bucket with secure defaults: private ACL, AES256 server-side encryption, and public access fully blocked.

## Resources

- `aws_s3_bucket`
- `aws_s3_bucket_ownership_controls` (BucketOwnerPreferred)
- `aws_s3_bucket_acl` (private)
- `aws_s3_bucket_versioning`
- `aws_s3_bucket_server_side_encryption_configuration` (AES256)
- `aws_s3_bucket_public_access_block` (all blocked)
- `aws_s3_bucket_lifecycle_configuration` (optional)

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `bucket_name` | `string` | *required* | The name of the S3 bucket |
| `versioning_enabled` | `bool` | `true` | Enable versioning on the bucket |
| `lifecycle_rules` | `list(object)` | `[]` | Lifecycle rules for object expiration |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The full `aws_s3_bucket` resource object |

## Example

```hcl
module "logs_bucket" {
  source = "git::https://github.com/diekotto/terraform-aws-modules.git//modules/s3?ref=main"

  bucket_name        = "my-app-logs"
  versioning_enabled = false

  lifecycle_rules = [
    {
      id     = "expire-old-logs"
      status = "Enabled"
      filter = { prefix = "logs/" }
      expiration = { days = 90 }
    }
  ]
}
```
