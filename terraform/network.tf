module "sample_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sample-vpc"
  cidr = "10.0.0.0/27"

  azs            = ["eu-central-1a", "eu-central-1b"]
  public_subnets = ["10.0.0.0/28", "10.0.0.16/28"]
}

resource "aws_security_group" "allow_http_sg" {
  name        = "allow-http-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.sample_vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}