output "ecr_repository_arn" {
  value       = module.ecr.ecr_repository_arn
  description = "Full ARN of the repository."
}

output "ecr_repository_name" {
  value       = module.ecr.ecr_repository_name
  description = "Name of first repository created"
}
