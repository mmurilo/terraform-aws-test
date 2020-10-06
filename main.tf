terraform {
  required_version = "~> 0.12"
  required_providers {
    aws = "~> 2.0"
  }
}

provider "aws" {
  version    = "~> 2.0"
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}
