output "ecr_repository_arn" {
  description = "Full ARN of the repository"
  value       = try(aws_ecr_repository.this[local.image_names[0]].arn, aws_ecrpublic_repository.this[local.image_names[0]].arn, null)
}

output "ecr_repository_name" {
  value       = try(aws_ecr_repository.this[local.image_names[0]].name, aws_ecrpublic_repository.this[local.image_names[0]].name, null)
  description = "Name of first repository created"
}

output "ecr_repository_registry_id" {
  value       = try(aws_ecr_repository.this[local.image_names[0]].registry_id, aws_ecrpublic_repository.this[local.image_names[0]].registry_id, null)
  description = "The registry ID where the repository was created."
}

output "ecr_repository_url" {
  value       = try(aws_ecr_repository.this[local.image_names[0]].repository_url, aws_ecrpublic_repository.this[local.image_names[0]].repository_url, null)
  description = "URL of first repository created"
}

output "repository_url_map" {
  value = zipmap(
    concat(values(aws_ecr_repository.this)[*].name, values(aws_ecrpublic_repository.this)[*].repository_name),
    concat(values(aws_ecr_repository.this)[*].repository_url, values(aws_ecrpublic_repository.this)[*].repository_uri)
  )
  description = "Map of repository names to repository URLs"
}

output "repository_arn_map" {
  value = zipmap(
    concat(values(aws_ecr_repository.this)[*].name, values(aws_ecrpublic_repository.this)[*].repository_name),
    concat(values(aws_ecr_repository.this)[*].arn, values(aws_ecrpublic_repository.this)[*].arn)
  )
  description = "Map of repository names to repository ARNs"
}


