# ============================================================
# RDS INSTANCE
# ============================================================

resource "aws_db_instance" "this" {
  count = var.manage_master_user_password ? 0 : 1

  # ----------------------------------------------------------
  # IDENTIFICATION
  # ----------------------------------------------------------

  identifier = "${var.environment}-${var.db_identifier}-db-instance"

  # ----------------------------------------------------------
  # ENGINE
  # ----------------------------------------------------------

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  # ----------------------------------------------------------
  # STORAGE
  # ----------------------------------------------------------

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  storage_encrypted = true

  # ----------------------------------------------------------
  # DATABASE
  # ----------------------------------------------------------

  db_name   = var.db_name
  username  = var.db_username
  password  = var.db_password

  # ----------------------------------------------------------
  # NETWORKING
  # ----------------------------------------------------------

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false

  # ----------------------------------------------------------
  # HIGH AVAILABILITY
  # ----------------------------------------------------------

  multi_az = var.multi_az

  # ----------------------------------------------------------
  # PARAMETER GROUP
  # ----------------------------------------------------------

  parameter_group_name = aws_db_parameter_group.this.name

  # ----------------------------------------------------------
  # MONITORING / OBSERVABILITY
  # ----------------------------------------------------------

  performance_insights_enabled    = var.performance_insights_enabled
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? aws_iam_role.rds_monitoring[0].arn : null

  # ----------------------------------------------------------
  # DEPLOYMENT BEHAVIOR
  # ----------------------------------------------------------

  apply_immediately = var.apply_immediately

  # ----------------------------------------------------------
  # DELETION PROTECTION
  # ----------------------------------------------------------

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.environment}-${var.db_identifier}-final"

  # ----------------------------------------------------------
  # TAGS
  # ----------------------------------------------------------

  tags = {
    Name        = "${var.environment}-${var.db_identifier}"
    Environment = var.environment
  }
}


# ============================================================
# RDS INSTANCE - AWS MANAGED MASTER PASSWORD
# ============================================================

resource "aws_db_instance" "managed_password" {
  count = var.manage_master_user_password ? 1 : 0

  # ----------------------------------------------------------
  # IDENTIFICATION
  # ----------------------------------------------------------

  identifier = "${var.environment}-${var.db_identifier}-db-instance"

  # ----------------------------------------------------------
  # ENGINE
  # ----------------------------------------------------------

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  # ----------------------------------------------------------
  # STORAGE
  # ----------------------------------------------------------

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  storage_encrypted = true

  # ----------------------------------------------------------
  # DATABASE
  # ----------------------------------------------------------

  db_name  = var.db_name
  username = var.db_username

  manage_master_user_password = true

  # ----------------------------------------------------------
  # NETWORKING
  # ----------------------------------------------------------

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false

  # ----------------------------------------------------------
  # HIGH AVAILABILITY
  # ----------------------------------------------------------

  multi_az = var.multi_az

  # ----------------------------------------------------------
  # PARAMETER GROUP
  # ----------------------------------------------------------

  parameter_group_name = aws_db_parameter_group.this.name

  # ----------------------------------------------------------
  # MONITORING / OBSERVABILITY
  # ----------------------------------------------------------

  performance_insights_enabled    = var.performance_insights_enabled
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? aws_iam_role.rds_monitoring[0].arn : null

  # ----------------------------------------------------------
  # DEPLOYMENT BEHAVIOR
  # ----------------------------------------------------------

  apply_immediately = var.apply_immediately

  # ----------------------------------------------------------
  # DELETION PROTECTION
  # ----------------------------------------------------------

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.environment}-${var.db_identifier}-final"

  # ----------------------------------------------------------
  # TAGS
  # ----------------------------------------------------------

  tags = {
    Name        = "${var.environment}-${var.db_identifier}"
    Environment = var.environment
  }
}