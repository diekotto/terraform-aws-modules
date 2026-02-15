variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "lifecycle_policy_enabled" {
  description = "Enable lifecycle policy for the repository"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Maximum number of images to keep in the repository (includes manifest lists and per-architecture images)"
  type        = number
  default     = 10
}

variable "repository_policy_enabled" {
  description = "Whether to attach a repository policy. When enabled without a custom policy, a default ECS pull policy is created"
  type        = bool
  default     = false
}

variable "repository_policy" {
  description = "Custom repository policy JSON. If null and repository_policy_enabled is true, a default ECS pull policy is used"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
