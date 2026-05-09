resource "aws_ecr_repository" "app" {
  name = var.repository_name

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name        = var.repository_name
    Environment = var.environment
    Project     = var.project_name
  }
}