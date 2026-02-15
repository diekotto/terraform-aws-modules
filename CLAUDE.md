# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Open-source collection of reusable, opinionated Terraform modules for AWS. Designed as a shared infrastructure library referenced by client projects via Git source URLs.

## Repository Structure

All modules live under `modules/<name>/`, each with a standard Terraform layout:
- `main.tf` — resource definitions
- `variables.tf` — input variables
- `outputs.tf` — exported values
- `versions.tf` — terraform and provider version constraints
- `README.md` — module-specific documentation

Current modules: `s3`, `ecr`, `ecs`, `alb`, `nlb`.

## Common Commands

```bash
# Validate a specific module
terraform -chdir=modules/s3 init -backend=false
terraform -chdir=modules/s3 validate

# Format all modules
terraform fmt -recursive modules/

# Format check (CI-friendly)
terraform fmt -recursive -check modules/
```

## Module Conventions

- **Provider constraints**: All modules require Terraform >= 1.0 and AWS provider >= 5.0 (defined in `versions.tf`). Modules do NOT declare a provider block — the caller supplies it.
- **Resource naming**: Primary resources use `"this"` as the Terraform resource name (e.g., `aws_s3_bucket.this`, `aws_lb.this`).
- **Tagging**: Every resource accepts a `tags` variable (`map(string)`, default `{}`), merged with a `Name` tag via `merge(var.tags, { Name = ... })`.
- **Outputs**: Expose full resource objects rather than individual attributes, so callers can access any attribute they need (e.g., `output "this" { value = aws_s3_bucket.this }`).
- **Security defaults**: Modules default to the more secure option (S3 public access blocked, ECR immutable tags, ECR scan-on-push enabled).
- **Optional sub-resources**: Use `count` with a boolean or length check to conditionally create resources (e.g., `count = var.lifecycle_policy_enabled ? 1 : 0`).

## Adding a New Module

1. Create `modules/<name>/` with `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`.
2. Copy the `versions.tf` block from an existing module to keep constraints consistent.
3. Follow the conventions above (resource named `"this"`, `tags` variable, full resource outputs).
4. Add a row to the root `README.md` modules table.
