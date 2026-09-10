
# ============================================================
# RDS INSTANCE
# ============================================================

output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_instance_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.identifier
}


# ============================================================
# DATABASE CONNECTION
# ============================================================

output "db_link_secret_endpoint" {
  description = "Endpoint of the database connection secret"
  value       = aws_db_instance.this.endpoint
  sensitive   = true
}

output "db_port" {
  description = "RDS database port"
  value       = aws_db_instance.this.port
}

output "db_host" {
  description = "RDS database hostname"
  value       = aws_db_instance.this.address
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "Database master username"
  value       = aws_db_instance.this.username
  sensitive   = true
}


# ============================================================
# NETWORKING
# ============================================================

output "db_subnet_group_name" {
  description = "RDS DB subnet group name"
  value       = aws_db_subnet_group.this.name
}

output "db_security_group_id" {
  description = "Security group associated with the RDS instance"
  value       = var.db_security_group_id
}


# ============================================================
# SECRETS MANAGER
# ============================================================

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the RDS master credentials"
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
  sensitive   = true
}


# ============================================================
# PARAMETER GROUP
# ============================================================

output "parameter_group_name" {
  description = "RDS parameter group name"
  value       = aws_db_parameter_group.this.name
}


# ============================================================
# DATABASE CONFIGURATION
# ============================================================

output "engine" {
  description = "RDS database engine"
  value       = aws_db_instance.this.engine
}

output "engine_version" {
  description = "RDS database engine version"
  value       = aws_db_instance.this.engine_version
}

output "instance_class" {
  description = "RDS instance class"
  value       = aws_db_instance.this.instance_class
}

output "multi_az" {
  description = "Whether Multi-AZ is enabled"
  value       = aws_db_instance.this.multi_az
}
