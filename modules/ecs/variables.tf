# ============================================================
# GENERAL
# ============================================================

variable "environment" {
  description = "Deployment environment"

  type = string

  default = "production"
}


variable "tags" {
  description = "Common resource tags"

  type = map(string)

  default = {}
}


# ============================================================
# NETWORK
# ============================================================

variable "aws_vpc_id" {
  description = "VPC ID"

  type = string
}


variable "aws_public_subnet_ids" {
  description = "Public subnet IDs used by the ALB"

  type = list(string)
}


variable "aws_private_subnet_ids" {
  description = "Private subnet IDs used by ECS tasks"

  type = list(string)
}


# ============================================================
# ECS CLUSTER
# ============================================================

variable "ecs_cluster_name" {
  description = "ECS cluster name"

  type = string

  default = "flask-production-cluster"
}

variable "container_insights_mode" {
  description = "ECS cluster container insights mode"

  type = string

  default = "enabled"
}


# ============================================================
# ECS SERVICE
# ============================================================

variable "ecs_service_name" {
  description = "ECS service name"

  type = string

  default = "flask-production-service"
}


variable "desired_count" {
  description = "Initial desired number of ECS tasks"

  type = number

  default = 2
}


variable "health_check_grace_period" {
  description = "Grace period for ECS service health checks"

  type = number

  default = 60
}


variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percentage during deployment"

  type = number

  default = 100
}


variable "deployment_maximum_percent" {
  description = "Maximum percentage during deployment"

  type = number

  default = 200
}


variable "enable_execute_command" {
  description = "Enable ECS Exec"

  type = bool

  default = true
}


# ============================================================
# TASK DEFINITION
# ============================================================

variable "ecs_task_name" {
  description = "ECS task name"

  type = string

  default = "flask-production-task"
}


variable "container_name" {
  description = "Container name"

  type = string

  default = "flask-app"
}

variable "requires_compatibilities" {
  description = "ECS task requires compatibilities"

  type = list(string)

  default = ["FARGATE"]
}

variable "task_cpu" {
  description = "Fargate task CPU units"

  type = number

  default = 512
}

variable "container_environment_variables" {
  description = "Environment variables for the container"

  type = map(string)

  default = {
    db_link =""
  }
}


variable "task_memory" {
  description = "Fargate task memory in MiB"

  type = number

  default = 1024
}


variable "container_cpu" {
  description = "Container CPU units"

  type = number

  default = 512
}


variable "container_memory" {
  description = "Container memory in MiB"

  type = number

  default = 1024
}


variable "container_port" {
  description = "Application container port"

  type = number

  default = 8000
}


variable "container_health_check_path" {
  description = "Application health check path"

  type = string

  default = "/health"
}

variable "health_check_grace_period_seconds" {
  description = "Health check interval in seconds"

  type = number

  default = 30
}


variable "environment_variables" {
  description = "Environment variables passed to the container"

  type = map(string)

  default = {}
}


variable "container_secrets" {
  description = "Secrets passed to the container"

  type = list(object({
    name       = string
    value_from = string
  }))

  default = []
}


# ============================================================
# ALB
# ============================================================

variable "alb_name" {
  description = "Application Load Balancer name"

  type = string

  default = "flask-production-alb"
}


variable "target_group_name" {
  description = "Target group name"

  type = string

  default = "flask-production-tg"
}


variable "enable_deletion_protection" {
  description = "Enable ALB deletion protection"

  type = bool

  default = false
}


variable "enable_https" {
  description = "Enable HTTPS security group rule"

  type = bool

  default = false
}

variable "acm_certificate_identifier" {
  description = "ACM certificate ARN for HTTPS"

  type = string

  default = "d8ef7687-8ba6-4530-919e-fbcef8ea27a1"
}


# ============================================================
# CLOUDWATCH
# ============================================================

variable "log_retention_in_days" {
  description = "CloudWatch log retention"

  type = number

  default = 30
}


# ============================================================
# AUTOSCALING
# ============================================================

variable "autoscaling_min_capacity" {
  description = "Minimum ECS task count"

  type = number

  default = 2
}


variable "autoscaling_max_capacity" {
  description = "Maximum ECS task count"

  type = number

  default = 6
}


variable "cpu_target_percentage" {
  description = "Target ECS CPU utilization"

  type = number

  default = 70
}


variable "memory_target_percentage" {
  description = "Target ECS memory utilization"

  type = number

  default = 75
}

# ============================================================
# IAM
# ============================================================

variable "ecs_execution_role_name" {
  description = "ECS execution role name"

  type = string

  default = "attaendance-execution-role"
}

variable "ecs_task_role_name" {
  description = "ECS task role name"

  type = string

  default = "attendance-task-role"
}