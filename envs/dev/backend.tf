terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket = "jb-tfstate-aps1-d14j2"
    key    = "envs/dev/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "jb-tf-state-lock"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
