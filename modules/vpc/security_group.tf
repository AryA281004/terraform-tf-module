resource "aws_security_group" "all-sg" {
        for_each = var.security_all_group
        name       = "${var.environment}-${each.key}-sg"
        description = each.value.description
        vpc_id      = aws_vpc.this.id

        ingress = each.value.ingress
        egress  = each.value.egress

        tags = {
            Name        = "${var.environment}-${each.key}-sg"
            Environment = var.environment
        }


}