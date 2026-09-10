resource "aws_security_group" "all-sg" {
  for_each    = var.security_all_group
  name        = "${var.environment}-${each.key}-sg"
  description = each.value.description
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name        = "${var.environment}-${each.key}-sg"
    Environment = var.environment
  }


}