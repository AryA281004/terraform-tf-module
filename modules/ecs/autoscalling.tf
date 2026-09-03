resource "aws_appautoscaling_target" "ecs" {
  max_capacity = var.autoscaling_max_capacity

  min_capacity = var.autoscaling_min_capacity

  resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"

  scalable_dimension = "ecs:service:DesiredCount"

  service_namespace = "ecs"

  depends_on = [
    aws_ecs_service.this
  ]

  tags = {
    Name        = "${var.environment}-${var.ecs_service_name}-autoscaling-target"
    Environment = var.environment
  }
}