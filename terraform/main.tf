terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "dev-sandbox"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
