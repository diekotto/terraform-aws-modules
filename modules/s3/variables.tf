variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type = list(object({
    id     = string
    status = string
    filter = optional(object({
      prefix = optional(string)
    }))
    expiration = optional(object({
      days = number
    }))
  }))
  default = []
}
