data "aws_iam_policy_document" "ecs_assumable_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "sample_app_task_role" {
  name               = "sample-app-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assumable_role_policy_document.json
}

data "aws_iam_policy_document" "sample_app_task_role_permissions" {
  statement {
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.sample_sqs_queue.arn]
  }
}

resource "aws_iam_role_policy" "task_role_policy_assignment" {
  role   = aws_iam_role.sample_app_task_role.id
  policy = data.aws_iam_policy_document.sample_app_task_role_permissions.json
}

resource "aws_iam_role" "sample_app_execution_role" {
  name               = "sample-app-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assumable_role_policy_document.json
}

data "aws_iam_policy_document" "sample_app_execution_role_permissions" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
  statement {
    actions   = ["ssm:GetParameters"]
    resources = [aws_ssm_parameter.sample_sqs_queue_url.arn]
  }
}

resource "aws_iam_role_policy" "execution_role_policy_assignment" {
  role   = aws_iam_role.sample_app_execution_role.id
  policy = data.aws_iam_policy_document.sample_app_execution_role_permissions.json
}
