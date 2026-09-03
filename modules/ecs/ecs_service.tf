# ============================================================
# AWS REGION
# ============================================================

data "aws_region" "current" {}


# ============================================================
# AWS ACCOUNT
# ============================================================

data "aws_caller_identity" "current" {}


# ============================================================
# ECS CLUSTER
# ============================================================

resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-${var.ecs_cluster_name}-cluster"

  setting {
    name  = "containerInsights"
    value = var.container_insights_mode
  }

  tags = {
    Name        = "${var.environment}-${var.ecs_cluster_name}-cluster"
    Environment = var.environment
  }
}


# ============================================================
# ECS TASK DEFINITION
# ============================================================

locals {
  container_name = "${var.environment}-${var.ecs_task_name}-container"
}


resource "aws_ecs_task_definition" "this" {

  family = "${var.environment}-${var.ecs_task_name}-task-definition"

  requires_compatibilities = var.requires_compatibilities
  network_mode             = "awsvpc"

  cpu    = var.task_cpu
  memory = var.task_memory

  task_role_arn      = aws_iam_role.ecs_task.arn
  execution_role_arn = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/attendance-app:latest"
      essential = true

      cpu    = var.container_cpu       
      memory = var.container_memory

      portMappings = [
        {
          name          = "${var.environment}-${var.ecs_task_name}-container-port-${var.container_port}"
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      environment = [
        for key, value in var.container_environment_variables : {
          name  = key
          value = value
        }
      ]


      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }

      healthCheck = {
        command = [
          "CMD-SHELL",
          "curl -f http://localhost:${var.container_port}${var.container_health_check_path} || exit 1"
        ]

        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      readonlyRootFilesystem = false
    }
  ])

  tags = {
    Name        = "${var.environment}-${var.ecs_task_name}-task"
    Environment = var.environment
  }
}

# ============================================================
# ECS SERVICE
# ============================================================

resource "aws_ecs_service" "this" {

  name = "${var.environment}-${var.ecs_service_name}-service"

  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.this.arn

  launch_type = "FARGATE"

  scheduling_strategy = "REPLICA"

  desired_count = var.desired_count

  # ----------------------------------------------------------
  # ECS FEATURES
  # ----------------------------------------------------------

  enable_ecs_managed_tags = true
  enable_execute_command  = var.enable_execute_command

  propagate_tags = "SERVICE"

  availability_zone_rebalancing = true

  # ----------------------------------------------------------
  # LOAD BALANCER HEALTH
  # ----------------------------------------------------------

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  # ----------------------------------------------------------
  # DEPLOYMENT
  # ----------------------------------------------------------

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # ----------------------------------------------------------
  # NETWORK CONFIGURATION
  # ----------------------------------------------------------

network_configuration {
  subnets = var.aws_private_subnet_ids

  security_groups = [
    aws_security_group.container-sg.id
  ]

  assign_public_ip = false
}

  # ----------------------------------------------------------
  # APPLICATION LOAD BALANCER
  # ----------------------------------------------------------

  load_balancer {

    target_group_arn = aws_lb_target_group.this.arn

    container_name = local.container_name

    container_port = var.container_port
  }

  # ----------------------------------------------------------
  # DEPENDENCIES
  # ----------------------------------------------------------

  depends_on = [
    aws_lb_listener.http_listener,
    aws_lb_listener.https_listener,
    aws_iam_role_policy_attachment.ecs_execution
  ]

  # ----------------------------------------------------------
  # AUTOSCALING
  # ----------------------------------------------------------

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

  # ----------------------------------------------------------
  # TAGS
  # ----------------------------------------------------------

  tags = {
    Name        = "${var.environment}-${var.ecs_service_name}-service"
    Environment = var.environment
  }
}