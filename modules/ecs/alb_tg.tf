resource "aws_lb_target_group" "this" {
  name = "${var.environment}-${var.alb_name}-alb-tg"

  port     = var.container_port
  protocol = "HTTP"

  target_type     = "ip"
  ip_address_type = "ipv4"

  vpc_id           = var.aws_vpc_id
  protocol_version = "HTTP1"

  health_check {
    path                = var.container_health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }



  tags = {
    Name        = "${var.environment}-${var.alb_name}-alb-tg"
    Environment = var.environment
  }

}