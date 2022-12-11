#  AWS ECR Module

AWS ECR Module which creates

-  KMS Key encryption
-  ECR lifecycle
-  ECR policy

## Usage
```hcl
module "ecr" {
    source  = "mattyait/ecr/aws"
    version = "1.0.0"

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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_kms_alias.kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.only_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.push_and_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | The encryption type to use for the repository. Valid values are `AES256` or `KMS` | `string` | `"AES256"` | no |
| <a name="input_image_names"></a> [image\_names](#input\_image\_names) | List of Docker local image names, used as repository names for AWS ECR | `list(string)` | `[]` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Whether images are allowed to overwrite existing tags. | `string` | `"MUTABLE"` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | The ARN of the KMS key to use when encryption\_type is `KMS`. If not specified when encryption\_type is `KMS`, uses a new KMS key. Otherwise, uses the default AWS managed key for ECR. | `string` | `null` | no |
| <a name="input_max_tagged_image_count"></a> [max\_tagged\_image\_count](#input\_max\_tagged\_image\_count) | The maximum number of tagged images that you want to retain in repository. | `number` | `30` | no |
| <a name="input_max_untagged_image_count"></a> [max\_untagged\_image\_count](#input\_max\_untagged\_image\_count) | The maximum number of untagged images that you want to retain in repository. | `number` | `1` | no |
| <a name="input_only_pull_accounts"></a> [only\_pull\_accounts](#input\_only\_pull\_accounts) | AWS accounts which pull only. | `list(string)` | `[]` | no |
| <a name="input_protected_tags"></a> [protected\_tags](#input\_protected\_tags) | Name of image tags prefixes that should not be destroyed. | `list(string)` | n/a | yes |
| <a name="input_push_and_pull_accounts"></a> [push\_and\_pull\_accounts](#input\_push\_and\_pull\_accounts) | AWS accounts which push and pull. | `list(string)` | `[]` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Whether images should automatically be scanned on push or not. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags for the resources | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repository_arn"></a> [ecr\_repository\_arn](#output\_ecr\_repository\_arn) | Full ARN of the repository. |
| <a name="output_ecr_repository_name"></a> [ecr\_repository\_name](#output\_ecr\_repository\_name) | Name of first repository created |
| <a name="output_ecr_repository_registry_id"></a> [ecr\_repository\_registry\_id](#output\_ecr\_repository\_registry\_id) | The registry ID where the repository was created. |
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | URL of first repository created |
| <a name="output_repository_arn_map"></a> [repository\_arn\_map](#output\_repository\_arn\_map) | Map of repository names to repository ARNs |
| <a name="output_repository_url_map"></a> [repository\_url\_map](#output\_repository\_url\_map) | Map of repository names to repository URLs |
<!-- END_TF_DOCS -->