########################################
# 1. OIDC Provider
########################################

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

########################################
# 2. IAM Role for GitHub Actions
########################################

resource "aws_iam_role" "github_actions" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:${var.github_repo}:ref:refs/heads/*",
              "repo:${var.github_repo}:pull_request"
            ]
          }
        }
      }
    ]
  })

  tags = {
    Name        = "github-actions-role"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

########################################
# 3. ECR Access Policy
########################################

resource "aws_iam_role_policy" "ecr_policy" {
  name = "github-ecr-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:DescribeRepositories",
          "ecr:DescribeImages"
        ]
        Resource = "*"
      }
    ]
  })
}

########################################
# 4. EKS Access (read cluster)
########################################

resource "aws_iam_role_policy" "eks_policy" {
  name = "github-eks-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster"
        ]
        Resource = "*"
      }
    ]
  })
}

########################################
# 5. Terraform Backend Access (S3 + DynamoDB)
########################################

resource "aws_iam_role_policy" "terraform_state_policy" {
  name = "github-terraform-state-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::shadikul-terraform-state-001"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::shadikul-terraform-state-001/*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ]
        Resource = "*"
      }
    ]
  })
}

########################################
# 6. Terraform Backend Permissions
########################################

resource "aws_iam_role_policy" "terraform_backend_policy" {
  name = "terraform-backend-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          "arn:aws:s3:::shadikul-terraform-state-001"
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "arn:aws:s3:::shadikul-terraform-state-001/*"
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ]

        Resource = "*"
      }
    ]
  })
}

########################################
# 6. Terraform Infrastructure Permissions
########################################

resource "aws_iam_role_policy" "terraform_infra_policy" {
  name = "terraform-infra-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          # EC2
          "ec2:*",

          # ECR
          "ecr:*",

          # EKS
          "eks:*",

          # IAM
          "iam:*",

          # Autoscaling
          "autoscaling:*",

          # Logs
          "logs:*",

          # CloudWatch
          "cloudwatch:*"
        ]

        Resource = "*"
      }
    ]
  })
}