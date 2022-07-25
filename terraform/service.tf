module "aws_ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name               = "sample-ecs-cluster"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}

resource "aws_ecs_task_definition" "sample_app_task_definition" {
  family                   = "sample-app-task-definition"
  task_role_arn            = aws_iam_role.sample_app_task_role.arn
  execution_role_arn       = aws_iam_role.sample_app_execution_role.arn
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = jsonencode([
    {
      name         = "sample-app"
      image        = "296142348249.dkr.ecr.eu-central-1.amazonaws.com/terraform-property-sample-app:latest"
      cpu          = 128
      memory       = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "sample_app_service" {
  name            = "sample-app"
  cluster         = module.aws_ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.sample_app_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = module.sample_vpc.public_subnets
    security_groups  = [aws_security_group.allow_http_sg.id]
    assign_public_ip = true
  }
}
