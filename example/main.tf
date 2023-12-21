terraform {
  required_version = ">=1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

module "ecr" {
  source = "../"

  image_names = [
    "test_private",
    "test1_private",
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

module "public_ecr" {
  source          = "../"
  repository_type = "public"
  image_names = [
    "test",
    "test1",
  ]

  public_repository_catalog_data = [
    {
      description       = "Docker container Description test repo"
      about_text        = "About Text test"
      usage_text        = "Usage Text test"
      operating_systems = ["Linux"]
      architectures     = ["x86"]
    },
    {
      description       = "Docker container Description test1 repo"
      about_text        = "About Text test1"
      usage_text        = "Usage Text test1"
      operating_systems = ["Alpine"]
      architectures     = ["x86"]
    }
  ]

  tags = {
    Environment = "demo"
    Created_By  = "Terraform"
  }
}
