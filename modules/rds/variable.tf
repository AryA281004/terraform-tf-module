variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}


variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "attendanceapp"
}


# ============================================================
# ENGINE
# ============================================================

variable "engine" {
  description = "RDS database engine"
  type        = string
  default     = "postgres"
}


variable "engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "18.3-R2"
}


variable "parameter_group_family" {
  description = "RDS parameter group family"
  type        = string
}


# ============================================================
# DATABASE
# ============================================================

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "mydb"
}


variable "db_username" {
  description = "Master username"
  type        = string
  default     = "postgres"
}

variable "manage_master_user_password" {
  description = "Let RDS generate and store the master password in Secrets Manager"
  type        = bool
  default     = true
}

variable "db_password" {
  description = "Master password when AWS-managed credentials are disabled"
  type        = string
  sensitive   = true
  default     = null
  nullable    = true

  validation {
    condition     = var.manage_master_user_password || (var.db_password != null && trimspace(var.db_password) != "")
    error_message = "db_password must be set when manage_master_user_password is false."
  }
}



# ============================================================
# INSTANCE
# ============================================================

variable "instance_class" {
  description = "RDS instance class"
  type        = string

}


# ============================================================
# STORAGE
# ============================================================

variable "allocated_storage" {
  description = "Initial storage size in GB"
  type        = number
}


variable "max_allocated_storage" {
  description = "Maximum storage size for autoscaling"
  type        = number
}


variable "storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}


# ============================================================
# NETWORKING
# ============================================================

variable "database_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)
}


variable "db_security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}


# ============================================================
# HIGH AVAILABILITY
# ============================================================

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}


# ============================================================
# CLOUDWATCH
# ============================================================

variable "enabled_cloudwatch_logs_exports" {
  description = "RDS logs exported to CloudWatch"
  type        = list(string)

  default = [
    "error",
    "slowquery"
  ]
}


# ============================================================
# PERFORMANCE INSIGHTS
# ============================================================

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}


# ============================================================
# ENHANCED MONITORING
# ============================================================

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds. 0 disables it."
  type        = number
  default     = 60

  validation {
    condition = contains(
      [0, 1, 5, 10, 15, 30, 60],
      var.monitoring_interval
    )

    error_message = "monitoring_interval must be 0, 1, 5, 10, 15, 30, or 60."
  }
}


# ============================================================
# DEPLOYMENT
# ============================================================

variable "apply_immediately" {
  description = "Apply modifications immediately"
  type        = bool
  default     = false
}


# ============================================================
# DELETION
# ============================================================

variable "deletion_protection" {
  description = "Prevent accidental deletion"
  type        = bool
  default     = true
}


variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the database"
  type        = bool
  default     = false
}