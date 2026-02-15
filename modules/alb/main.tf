resource "aws_security_group" "alb" {
  name_prefix = "${var.name}-alb-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-alb-sg"
  })
}

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
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
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = var.target_protocol
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(var.tags, {
    Name = "${var.name}-tg"
  })
}

resource "aws_lb_listener" "http" {
  count             = var.certificate_arn != null ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  count             = var.certificate_arn != null ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "http_only" {
  count             = var.certificate_arn == null ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
