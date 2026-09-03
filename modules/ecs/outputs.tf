# ============================================================
# ECS
# ============================================================

output "cluster_id" {
  description = "ECS cluster ID"

  value = aws_ecs_cluster.this.id
}


output "cluster_name" {
  description = "ECS cluster name"

  value = aws_ecs_cluster.this.name
}


output "service_id" {
  description = "ECS service ID"

  value = aws_ecs_service.this.id
}


output "ecs_service_name" {
  description = "ECS service name"

  value = aws_ecs_service.this.name
}


output "task_definition_arn" {
  description = "ECS task definition ARN"

  value = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "ECS task definition family"

  value = aws_ecs_task_definition.this.family
}

output "task_definition_revision" {
  description = "ECS task definition revision"

  value = aws_ecs_task_definition.this.revision
}




# ============================================================
# ALB
# ============================================================

output "alb_id" {
  description = "Application Load Balancer ID"

  value = aws_lb.this.id
}


output "alb_dns_name" {
  description = "Application Load Balancer DNS name"

  value = aws_lb.this.dns_name
}


output "alb_zone_id" {
  description = "Application Load Balancer hosted zone ID"

  value = aws_lb.this.zone_id
}


output "target_group_arn" {
  description = "ECS target group ARN"

  value = aws_lb_target_group.ecs.arn
}


# ============================================================
# SECURITY GROUPS
# ============================================================

output "alb_security_group_id" {
  description = "ALB security group ID"

  value = aws_security_group.alb.id
}


output "ecs_security_group_id" {
  description = "ECS task security group ID"

  value = aws_security_group.ecs_tasks.id
}


# ============================================================
# CLOUDWATCH
# ============================================================

output "log_group_name" {
  description = "CloudWatch log group"

  value = aws_cloudwatch_log_group.ecs.name
}


# ============================================================
# IAM
# ============================================================

output "ecs_execution_role_arn" {
  description = "ECS execution role ARN"

  value = aws_iam_role.ecs_execution.arn
}


output "ecs_task_role_arn" {
  description = "ECS task role ARN"

  value = aws_iam_role.ecs_task.arn
}