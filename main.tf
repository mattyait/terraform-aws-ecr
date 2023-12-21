locals {
  encryption_configuration = var.encryption_type != "KMS" ? [] : [
    {
      encryption_type = "KMS"
      kms_key         = var.encryption_type == "KMS" && var.kms_key == null ? aws_kms_key.kms_key[0].arn : var.kms_key
    }
  ]
  image_names = length(var.image_names) > 0 ? var.image_names : []

  create_private_repository = var.repository_type == "private"
  create_public_repository  = var.repository_type == "public"
}


locals {
  untagged_image_rule = [{
    rulePriority = length(var.protected_tags) + 1
    description  = "Remove untagged images"
    selection = {
      tagStatus   = "untagged"
      countType   = "imageCountMoreThan"
      countNumber = var.max_untagged_image_count
    }
    action = {
      type = "expire"
    }
  }]

  remove_old_image_rule = [{
    rulePriority = length(var.protected_tags) + 2
    description  = "Rotate images when reach ${var.max_tagged_image_count} images stored",
    selection = {
      tagStatus   = "any"
      countType   = "imageCountMoreThan"
      countNumber = var.max_tagged_image_count
    }
    action = {
      type = "expire"
    }
  }]

  protected_tag_rules = [
    for index, tagPrefix in zipmap(range(length(var.protected_tags)), tolist(var.protected_tags)) :
    {
      rulePriority = tonumber(index) + 1
      description  = "Protects images tagged with ${tagPrefix}"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = [tagPrefix]
        countType     = "imageCountMoreThan"
        countNumber   = 999999
      }
      action = {
        type = "expire"
      }
    }
  ]
}

locals {
  current_account        = format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
  only_pull_accounts     = concat([local.current_account], var.only_pull_accounts)
  push_and_pull_accounts = concat([local.current_account], var.push_and_pull_accounts)
}

resource "aws_kms_key" "kms_key" {
  count       = (local.create_private_repository && var.encryption_type == "KMS" && var.kms_key == null) ? 1 : 0
  description = "ECR KMS key for ECR"
  tags        = var.tags
}

resource "aws_kms_alias" "kms_key_alias" {
  count         = (local.create_private_repository && var.encryption_type == "KMS" && var.kms_key == null) ? 1 : 0
  name          = "alias/ecrkey"
  target_key_id = aws_kms_key.kms_key[0].key_id
}

resource "aws_ecr_repository" "this" {
  for_each             = local.create_private_repository ? toset(local.image_names) : []
  name                 = each.value
  image_tag_mutability = var.image_tag_mutability

  dynamic "encryption_configuration" {
    for_each = local.encryption_configuration
    content {
      encryption_type = lookup(encryption_configuration.value, "encryption_type")
      kms_key         = lookup(encryption_configuration.value, "kms_key")
    }

  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  tags = var.tags
}

resource "aws_ecr_repository_policy" "this" {
  for_each   = local.create_private_repository ? toset(local.image_names) : []
  repository = aws_ecr_repository.this[each.value].name
  policy     = data.aws_iam_policy_document.push_and_pull.json
}

data "aws_iam_policy_document" "only_pull" {
  statement {
    sid    = "ElasticContainerRegistryOnlyPull"
    effect = "Allow"

    principals {
      identifiers = local.only_pull_accounts
      type        = "AWS"
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
}

# Allows specific accounts to push and pull images
data "aws_iam_policy_document" "push_and_pull" {
  source_policy_documents = [data.aws_iam_policy_document.only_pull.json]

  statement {
    sid    = "ElasticContainerRegistryPushAndPull"
    effect = "Allow"

    principals {
      identifiers = local.push_and_pull_accounts
      type        = "AWS"
    }

    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = local.create_private_repository ? toset(local.image_names) : []
  repository = aws_ecr_repository.this[each.value].name
  policy = jsonencode({
    rules = concat(local.protected_tag_rules, local.untagged_image_rule, local.remove_old_image_rule)
  })
}



data "aws_caller_identity" "current" {}



resource "aws_ecrpublic_repository" "this" {
  for_each   = local.create_public_repository ? toset(local.image_names) : []

  repository_name = each.value

  dynamic "catalog_data" {
    for_each = length(var.public_repository_catalog_data) > 0 ? [var.public_repository_catalog_data] : []
    content {
      about_text        = try(catalog_data.value[index(local.image_names, each.value)].about_text, null)
      architectures     = try(catalog_data.value[index(local.image_names, each.value)].architectures, null)
      description       = try(catalog_data.value[index(local.image_names, each.value)].description, null)
      logo_image_blob   = try(catalog_data.value[index(local.image_names, each.value)].logo_image_blob, null)
      operating_systems = try(catalog_data.value[index(local.image_names, each.value)].operating_systems, null)
      usage_text        = try(catalog_data.value[index(local.image_names, each.value)].usage_text, null)
    }
  }

  tags = var.tags
}
