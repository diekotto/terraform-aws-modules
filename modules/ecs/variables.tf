variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "image_uri" {
  description = "The Docker image URI to deploy"
  type        = string
}

variable "container_port" {
  description = "The port on which the container listens"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "The amount of CPU to allocate to the container (in CPU units)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "The amount of memory to allocate to the container (in MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "The desired number of task instances"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "The VPC ID where the ECS service will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the ECS service will be deployed"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the task ENI"
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "Environment variables to pass to the container"
  type        = map(string)
  default     = {}
}

variable "health_check" {
  description = "Container health check configuration. Set to null to disable"
  type = object({
    command     = list(string)
    interval    = optional(number, 30)
    timeout     = optional(number, 5)
    retries     = optional(number, 3)
    startPeriod = optional(number, 60)
  })
  default = null
}

variable "cluster_arn" {
  description = "ARN of an existing ECS cluster. If null, a new cluster is created"
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

variable "enable_load_balancer" {
  description = "Whether to enable load balancer integration"
  type        = bool
  default     = false
}

variable "allow_anywhere_access" {
  description = "Whether to allow access from anywhere when load balancer is disabled (not recommended for production)"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "ARN of the target group to attach the service to (required if enable_load_balancer is true)"
  type        = string
  default     = null

  validation {
    condition     = !var.enable_load_balancer || var.target_group_arn != null
    error_message = "target_group_arn is required when enable_load_balancer is true."
  }
}

variable "load_balancer_security_group_id" {
  description = "Security group ID of the load balancer for ingress rules"
  type        = string
  default     = null
}

variable "task_role_arn" {
  description = "ARN of the IAM role for the task containers (grants permissions to the application, e.g. S3/DynamoDB access)"
  type        = string
  default     = null
}

variable "architecture" {
  description = "The CPU architecture (X86_64 or ARM64)"
  type        = string
  default     = "ARM64"

  validation {
    condition     = contains(["X86_64", "ARM64"], var.architecture)
    error_message = "Architecture must be either X86_64 or ARM64."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
