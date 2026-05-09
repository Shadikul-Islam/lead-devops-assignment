output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_repository_arn" {
  value = module.ecr.repository_arn
}

output "github_actions_role_arn" {
  value = module.github_oidc.github_actions_role_arn
}