resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(var.tags, {
    Name = var.repository_name
  })
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.lifecycle_policy_enabled ? 1 : 0
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.repository_policy_enabled ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy != null ? var.repository_policy : data.aws_iam_policy_document.ecs_pull[0].json
}

data "aws_iam_policy_document" "ecs_pull" {
  count = var.repository_policy_enabled && var.repository_policy == null ? 1 : 0

  statement {
    sid    = "AllowECSTaskPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalServiceName"
      values   = ["ecs-tasks.amazonaws.com"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
}

data "aws_caller_identity" "current" {}
