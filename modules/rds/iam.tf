# ============================================================
# RDS ENHANCED MONITORING ROLE
# ============================================================

resource "aws_iam_role" "rds_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  name = "${var.environment}-${var.db_identifier}-rds-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-${var.db_identifier}-rds-monitoring"
    Environment = var.environment
  }
}


# ============================================================
# RDS ENHANCED MONITORING POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  role = aws_iam_role.rds_monitoring[0].name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}