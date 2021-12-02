#  AWS ECR Module

AWS ECR Module which creates

-  KMS Key encryption
-  ECR lifecycle
-  ECR policy

## Usage

    module "ecr" {
    source  = "mattyait/ecr/aws"
    version = "0.1.0"

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
