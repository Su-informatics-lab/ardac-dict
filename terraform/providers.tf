terraform {
  backend "s3" {
    key    = "ardac-dictionary/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  shared_config_files      = var.config
  shared_credentials_files = var.credentials
  profile                  = var.profile
  region                   = var.region
}
