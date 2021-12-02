
output "ecr_repository_arn" {
  value       = aws_ecr_repository.this[local.image_names[0]].arn
  description = "Full ARN of the repository."
}

output "ecr_repository_name" {
  value       = aws_ecr_repository.this[local.image_names[0]].name
  description = "Name of first repository created"
}

output "ecr_repository_registry_id" {
  value       = aws_ecr_repository.this[local.image_names[0]].registry_id
  description = "The registry ID where the repository was created."
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.this[local.image_names[0]].repository_url
  description = "URL of first repository created"
}

output "repository_url_map" {
  value = zipmap(
    values(aws_ecr_repository.this)[*].name,
    values(aws_ecr_repository.this)[*].repository_url
  )
  description = "Map of repository names to repository URLs"
}

output "repository_arn_map" {
  value = zipmap(
    values(aws_ecr_repository.this)[*].name,
    values(aws_ecr_repository.this)[*].arn
  )
  description = "Map of repository names to repository ARNs"
}