resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-${var.db_identifier}-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name        = "${var.environment}-${var.db_identifier}-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.environment}-${var.db_identifier}-parameters"
  family = var.parameter_group_family

  tags = {
    Name        = "${var.environment}-${var.db_identifier}-parameters"
    Environment = var.environment
  }
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

  secret_id = aws_secretsmanager_secret.db_link[0].id

  secret_string = "postgresql://${var.db_username}:${urlencode(var.db_password)}@${aws_db_instance.this[0].address}:${aws_db_instance.this[0].port}/${var.db_name}"
}