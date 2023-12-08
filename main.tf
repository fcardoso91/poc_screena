// this will detect 0.10.8 (the latest 0.10.x release)
terraform {
  required_version = "~> 1.5.7, <1.6.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.24.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}