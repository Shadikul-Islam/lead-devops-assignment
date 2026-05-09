module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr     = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]

  project_name = "nodejs-eks"
  environment  = "prod"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name = "nodejs-eks-prod"

  subnet_ids = module.vpc.private_subnets
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "nodejs-app"
  environment     = var.environment
  project_name    = var.project_name
}