terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.53.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  # access_key = "${var.AWS_ID}"
  # secret_key = "${var.AWS_SECRET}"
}