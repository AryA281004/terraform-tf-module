resource "aws_lb_target_group" "this" {
    name              = "${var.environment}-${var.alb_name}-alb-tg"

    port              = var.container_port
    protocol          = "HTTP"

    target_type      = "ip"
    ip_address_type  = "ipv4"

    vpc_id            = aws_vpc.this.id
    protocol_version  = "HTTP1"

    health_check {
        path                = "/login"
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

resource "aws_lb_listener" "this" {
    load_balancer_arn = aws_lb.this.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.this.arn
      }
    }
  }

  tags = {
      Name        = "${var.environment}-${var.alb_name}-http-listener"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  
}