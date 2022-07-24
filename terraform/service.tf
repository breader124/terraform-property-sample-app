resource "aws_ecs_cluster" "cluster" {
  name = "sample-ecs-cluster"
}

resource "aws_ecs_task_definition" "sample_app_task_definition" {
  family                   = "service"
  task_role_arn            = aws_iam_role.sample_app_task_role.arn
  execution_role_arn       = aws_iam_role.sample_app_execution_role.arn
#  TODO requires research
#  requires_compatibilities = ["FARGATE"]
#  cpu                      = "10"
#  memory                   = "512"
#  network_mode             = "awsvpc"
  container_definitions    = jsonencode([
    {
      name         = "sample-app"
      image        = "296142348249.dkr.ecr.eu-central-1.amazonaws.com/terraform-property-sample-app:latest"
      cpu          = 128
      memory       = 512
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "sample_app_service" {
  name            = "sample-app"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.sample_app_task_definition.arn
  desired_count   = 1
#  TODO requires research
#  launch_type     = "FARGATE"
}
