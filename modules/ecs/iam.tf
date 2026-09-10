resource "aws_iam_role" "ecs_execution" {
  name = "${var.environment}-${var.ecs_execution_role_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-${var.ecs_execution_role_name}-role"
    Environment = var.environment
  }
}


resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role = aws_iam_role.ecs_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role_policy" "ecs_execution_secrets" {
  count = length(var.container_secrets) > 0 ? 1 : 0

  name = "${var.environment}-ecs-execution-secrets"

  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = [
          for secret in var.container_secrets : secret.value_from
        ]
      }
    ]
  })
}


resource "aws_iam_role" "ecs_task" {
  name = "${var.environment}-${var.ecs_task_role_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-${var.ecs_task_role_name}-role"
    Environment = var.environment
  }
}