
# ============================================================
# RDS INSTANCE
# ============================================================

output "db_instance_id" {
  description = "RDS instance ID"
  value       = try(aws_db_instance.this[0].id, aws_db_instance.managed_password[0].id)
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = try(aws_db_instance.this[0].arn, aws_db_instance.managed_password[0].arn)
}

output "db_instance_identifier" {
  description = "RDS instance identifier"
  value       = try(aws_db_instance.this[0].identifier, aws_db_instance.managed_password[0].identifier)
}


# ============================================================
# DATABASE CONNECTION
# ============================================================

output "db_link_secret_endpoint" {
  description = "Endpoint of the database connection secret"
  value       = try(aws_db_instance.this[0].endpoint, aws_db_instance.managed_password[0].endpoint)
  sensitive   = true
}

output "db_port" {
  description = "RDS database port"
  value       = try(aws_db_instance.this[0].port, aws_db_instance.managed_password[0].port)
}

output "db_host" {
  description = "RDS database hostname"
  value       = try(aws_db_instance.this[0].address, aws_db_instance.managed_password[0].address)
}

output "db_name" {
  description = "Database name"
  value       = try(aws_db_instance.this[0].db_name, aws_db_instance.managed_password[0].db_name)
}

output "db_username" {
  description = "Database master username"
  value       = try(aws_db_instance.this[0].username, aws_db_instance.managed_password[0].username)
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
  value       = try(aws_db_instance.managed_password[0].master_user_secret[0].secret_arn, null)
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
  value       = try(aws_db_instance.this[0].engine, aws_db_instance.managed_password[0].engine)
}

output "engine_version" {
  description = "RDS database engine version"
  value       = try(aws_db_instance.this[0].engine_version, aws_db_instance.managed_password[0].engine_version)
}

# ============================================================
# DATABASE LINK SECRET ARN
# ============================================================

output "db_link_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the database connection URL"
  value       = try(aws_secretsmanager_secret.db_link[0].arn, null)
  sensitive   = true
}

output "instance_class" {
  description = "RDS instance class"
  value       = try(aws_db_instance.this[0].instance_class, aws_db_instance.managed_password[0].instance_class)
}

output "multi_az" {
  description = "Whether Multi-AZ is enabled"
  value       = try(aws_db_instance.this[0].multi_az, aws_db_instance.managed_password[0].multi_az)
}
