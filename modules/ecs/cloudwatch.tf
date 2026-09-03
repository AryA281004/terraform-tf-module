resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.environment}-${var.ecs_cluster_name}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name        = "/ecs/${var.environment}-${var.ecs_cluster_name}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}