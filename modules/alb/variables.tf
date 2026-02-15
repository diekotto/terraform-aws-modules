variable "name" {
  description = "The name of the load balancer"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the load balancer will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the load balancer will be deployed (must be in different AZs)"
  type        = list(string)
}

variable "internal" {
  description = "Whether the load balancer is internal or internet-facing"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access the ALB on ports 80 and 443"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_port" {
  description = "The port on which the targets are listening"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "The protocol to use for routing traffic to the targets"
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.target_protocol)
    error_message = "Target protocol must be HTTP or HTTPS."
  }
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate to use for HTTPS listeners (if null, only HTTP listener will be created)"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "The SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "health_check_path" {
  description = "The destination for health checks on the targets"
  type        = string
  default     = "/"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response from a target means a failed health check"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target"
  type        = string
  default     = "200"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
