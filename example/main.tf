terraform {
  required_version = ">=1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "ecr" {
  source = "../"

  image_names = [
    "test",
    "test1",
  ]
  scan_on_push         = true
  image_tag_mutability = "IMMUTABLE"

  max_untagged_image_count = 5
  max_tagged_image_count   = 50
  protected_tags           = ["latest"]

  tags = {
    Environment = "demo"
    Created_By  = "Terraform"
  }
}

module "ecr_with_kms" {
  source = "../"

  image_names = [
    "kms_repo",
    "kms_repo1",
  ]
  encryption_type      = "KMS"
  scan_on_push         = true
  image_tag_mutability = "IMMUTABLE"

  max_untagged_image_count = 5
  max_tagged_image_count   = 50
  protected_tags           = ["latest"]

  tags = {
    Environment = "demo"
    Created_By  = "Terraform"
  }
}
