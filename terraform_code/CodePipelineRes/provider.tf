terraform {
    required_providers {
      aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
      }
    }

    backend "s3" {
      bucket = "terraform-codepipeline-lambda"
      key    = "apiCodePipelineStateFile"
      region = "us-east-1"
    }
}

provider "aws" {
  region = var.region
}