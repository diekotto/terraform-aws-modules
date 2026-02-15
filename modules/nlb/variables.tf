variable "name" {
  description = "The name of the network load balancer"
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

variable "target_port" {
  description = "The port on which the targets are listening"
  type        = number
  default     = 80
}

variable "listener_port" {
  description = "The port on which the load balancer listens"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "The protocol to use for routing traffic to the targets"
  type        = string
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "UDP", "TCP_UDP", "TLS"], var.target_protocol)
    error_message = "Target protocol must be TCP, UDP, TCP_UDP, or TLS."
  }
}

variable "listener_protocol" {
  description = "The protocol for the load balancer listener"
  type        = string
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "UDP", "TCP_UDP", "TLS"], var.listener_protocol)
    error_message = "Listener protocol must be TCP, UDP, TCP_UDP, or TLS."
  }
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate to use for TLS listeners (only required if listener_protocol is TLS)"
  type        = string
  default     = null
}

variable "health_check_enabled" {
  description = "Whether health checks are enabled"
  type        = bool
  default     = true
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "health_check_port" {
  description = "The port to use for health checks (defaults to target port)"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "The protocol to use for health checks"
  type        = string
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "HTTP", "HTTPS"], var.health_check_protocol)
    error_message = "Health check protocol must be TCP, HTTP, or HTTPS."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
