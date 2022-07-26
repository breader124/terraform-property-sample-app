resource "aws_sqs_queue" "sample_sqs_queue" {
  name = "sample-sqs-queue"
}

resource "aws_ssm_parameter" "sample_sqs_queue_url" {
  name  = "demo-queue-url"
  type  = "String"
  value = aws_sqs_queue.sample_sqs_queue.url
}
