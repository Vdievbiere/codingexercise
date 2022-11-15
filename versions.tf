terraform {
  # configured backend(s3, db table to store tfstatefile)

  # backend "aws" {
  #   bucket = ""
  #   key = ""
  #   region = "us-east-1"
  #   dynamodb = "" 
  #   encrypt = true 
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.1"
    }
  }
}