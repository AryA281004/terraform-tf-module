terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
   
}
provider "aws" {
  region = "us-east-1"
}

# ============================================================
# DB SUBNET GROUP
# ============================================================

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-${var.db_identifier}-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name        = "${var.environment}-${var.db_identifier}-subnet-group"
    Environment = var.environment
  }
}


# ============================================================
# DB PARAMETER GROUP
# ============================================================

resource "aws_db_parameter_group" "this" {
  name   = "${var.environment}-${var.db_identifier}-parameter-group"
  family = var.parameter_group_family

  tags = {
    Name        = "${var.environment}-${var.db_identifier}-parameter-group"
    Environment = var.environment
  }
}


# ============================================================
# RDS INSTANCE
# ============================================================

resource "aws_db_instance" "this" {

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

  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.manage_master_user_password ? null : var.db_password
  manage_master_user_password = var.manage_master_user_password


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
# DB_LINK SECRET
# Only buildable when we know the password ourselves, i.e. when
# manage_master_user_password = false and db_password was supplied.
# ============================================================

locals {
  db_link_scheme = var.engine == "postgres" ? "postgresql" : var.engine

  db_link = var.manage_master_user_password ? null : "${local.db_link_scheme}://${var.db_username}:${var.db_password}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${var.db_name}"
}

resource "aws_secretsmanager_secret" "db_link" {
  count = var.manage_master_user_password ? 0 : 1

  name = "${var.environment}-${var.db_identifier}-db-link"

  tags = {
    Name        = "${var.environment}-${var.db_identifier}-db-link"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_link" {
  count = var.manage_master_user_password ? 0 : 1

  secret_id     = aws_secretsmanager_secret.db_link[0].id
  secret_string = local.db_link
}