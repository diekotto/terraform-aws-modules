resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(var.tags, {
    Name = "${var.name}-tg"
  })
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  certificate_arn   = var.listener_protocol == "TLS" ? var.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
