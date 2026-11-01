terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.80" }
  }
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}
provider "aws" {
  region = var.aws_region
  default_tags { tags = { Project = "oficina-mecanica", Repository = "oficina-infra-dynamo", Environment = var.environment, ManagedBy = "terraform" } }
}
