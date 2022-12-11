variable "image_names" {
  type        = list(string)
  default     = []
  description = "List of Docker local image names, used as repository names for AWS ECR "
}

variable "protected_tags" {
  type        = list(string)
  description = "Name of image tags prefixes that should not be destroyed."
}

variable "only_pull_accounts" {
  default     = []
  type        = list(string)
  description = "AWS accounts which pull only."
}

variable "push_and_pull_accounts" {
  default     = []
  type        = list(string)
  description = "AWS accounts which push and pull."
}

variable "max_untagged_image_count" {
  default     = 1
  type        = number
  description = "The maximum number of untagged images that you want to retain in repository."
}

variable "max_tagged_image_count" {
  default     = 30
  type        = number
  description = "The maximum number of tagged images that you want to retain in repository."
}

variable "scan_on_push" {
  default     = false
  type        = bool
  description = "Whether images should automatically be scanned on push or not."
}

variable "image_tag_mutability" {
  default     = "MUTABLE"
  type        = string
  description = "Whether images are allowed to overwrite existing tags."
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are `AES256` or `KMS`"
  type        = string
  default     = "AES256"
}

# KMS key
variable "kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified when encryption_type is `KMS`, uses a new KMS key. Otherwise, uses the default AWS managed key for ECR."
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags for the resources"
  type    = map(any)
  default = {}
}
