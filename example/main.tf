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
  protected_tags      = ["latest"]

  tags = {    
    Environment = "demo"
    Created_By  = "Terraform"
  }
}
