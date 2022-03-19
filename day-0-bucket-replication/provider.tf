terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "east-2"
}

provider "aws" {
  region = "us-west-2"
  alias  = "west-2"
}
