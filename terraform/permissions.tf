data "aws_iam_policy_document" "ecs_assumable_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Task role

resource "aws_iam_role" "sample_app_task_role" {
  name               = "sample-app-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assumable_role_policy_document.json
}

# Execution role

resource "aws_iam_role" "sample_app_execution_role" {
  name               = "sample-app-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assumable_role_policy_document.json
}

data "aws_iam_policy_document" "sample_app_execution_role_permissions" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "execution_role_get_images_from_ecr" {
  role   = aws_iam_role.sample_app_execution_role.id
  policy = data.aws_iam_policy_document.sample_app_execution_role_permissions.json
}
