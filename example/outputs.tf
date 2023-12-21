output "public_ecr_repository_url_map" {
  value       = try(module.public_ecr.repository_url_map, null)
  description = "Returning the ecr repo url as map"
}

output "public_repository_arn_map" {
  value       = try(module.public_ecr.repository_arn_map, null)
  description = "Returning the ecr repo arn as map"
}

output "private_ecr_repository_url_map" {
  value       = try(module.ecr.repository_url_map, null)
  description = "Returning the ecr repo url as map"
}

output "private_repository_arn_map" {
  value       = try(module.ecr.repository_arn_map, null)
  description = "Returning the ecr repo arn as map"
}
