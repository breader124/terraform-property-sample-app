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

resource "aws_iam_role" "sample_app_execution_role" {
  name               = "sample-app-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assumable_role_policy_document.json
}
