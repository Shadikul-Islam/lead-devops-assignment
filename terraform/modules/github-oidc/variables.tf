variable "github_repo" {
  type        = string
  description = "GitHub repo in format username/repo"
}

variable "role_name" {
  type    = string
  default = "github-actions-eks-role"
}
