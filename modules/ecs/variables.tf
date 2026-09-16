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


variable "alb_security_group_id" {
  description = "Security group ID to attach to the ALB"

  type = string
}


variable "container_security_group_id" {
  description = "Security group ID to attach to the ECS containers"

  type = string
}


# ============================================================
# ECS CLUSTER
# ============================================================

variable "ecs_cluster_name" {
  description = "ECS cluster name"

  type = string

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

  
}


variable "desired_count" {
  description = "Initial desired number of ECS tasks"

  type = number

  
}


variable "health_check_grace_period" {
  description = "Grace period for ECS service health checks"

  type = number

 
}


variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percentage during deployment"

  type = number

}


variable "deployment_maximum_percent" {
  description = "Maximum percentage during deployment"

  type = number

 
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

}


variable "container_name" {
  description = "Container name"

  type = string

 
}

variable "requires_compatibilities" {
  description = "ECS task requires compatibilities"

  type = list(string)

  default = ["FARGATE"]
}

variable "task_cpu" {
  description = "Fargate task CPU units"

  type = number


}

variable "container_environment_variables" {
  description = "Environment variables for the container"

  type = map(string)

  default = {
  }
}


variable "task_memory" {
  description = "Fargate task memory in MiB"

  type = number

 
}


variable "container_cpu" {
  description = "Container CPU units"

  type = number

 
}


variable "container_memory" {
  description = "Container memory in MiB"

  type = number

  
}


variable "container_port" {
  description = "Application container port"

  type = number


}


variable "container_image" {
  description = "Docker image URI for the container"

  type = string

}


variable "container_health_check_path" {
  description = "Application health check path"

  type = string

 
}

variable "health_check_grace_period_seconds" {
  description = "Health check interval in seconds"

  type = number

}


variable "environment_variables" {
  description = "Environment variables passed to the container"

  type = map(string)

  default = {}
}


variable "container_secrets" {
  description = "Secrets injected into the ECS container"

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

}


variable "target_group_name" {
  description = "Target group name"

  type = string

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

 
}


# ============================================================
# AUTOSCALING
# ============================================================

variable "autoscaling_min_capacity" {
  description = "Minimum ECS task count"

  type = number

  
}


variable "autoscaling_max_capacity" {
  description = "Maximum ECS task count"

  type = number

  
}


variable "cpu_target_percentage" {
  description = "Target ECS CPU utilization"

  type = number

  
}


variable "memory_target_percentage" {
  description = "Target ECS memory utilization"

  type = number

 
}

# ============================================================
# IAM
# ============================================================

variable "ecs_execution_role_name" {
  description = "ECS execution role name"

  type = string

  
}

variable "ecs_task_role_name" {
  description = "ECS task role name"

  type = string

  
}