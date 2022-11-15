
provider "aws" {
  region = var.region

  default_tags {
    tags = local.required_tags
  }
}