terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "subodha-demo-terraform-eks-state-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "terraform-eks-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  cluster_name              = var.cluster_name
  availability_zones        = var.availability_zones
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_subnet_cidrs      = var.private_subnet_cidrs
  vpc_cidr                  = var.vpc_cidr
  enable_single_nat_gateway = var.enable_single_nat_gateway
  environment               = var.environment
}

module "eks" {
  source = "./modules/eks"

  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  subnet_ids       = module.vpc.private_subnet_ids
  node_groups      = var.node_groups
  vpc_id           = module.vpc.vpc_id
  bastion_role_arn = module.iam.bastion_role_arn
  environment      = var.environment
}

module "iam" {
  source               = "./modules/iam"
  cluster_name         = var.cluster_name
  oidc_issuer_url      = module.eks.oidc_issuer_url
  namespace            = var.namespace
  service_account_name = var.service_account_name
  environment          = var.environment
}

# -----------------------------------------------------------------------------
# Bastion Host Module (Future Enhancement)
# Requires: key pair created in AWS, bastion variables set in tfvars
# -----------------------------------------------------------------------------
#
# module "bastion" {
#   source = "./modules/Bastion"

#   bastion_ami_name            = var.bastion_ami_name
#   bastion_instance_type       = var.bastion_instance_type
#   bastion_subnet_id           = module.vpc.public_subnet_ids[0]
#   bastion_sg_id               = module.vpc.bastion_sg_id
#   cluster_name                = var.cluster_name
#   bastion_instance_profile    = module.iam.bastion_instance_profile_arn
#   key_pair_name               = var.bastion_key_pair_name
#   repo_url                    = var.bastion_repo_url
#   environment                 = var.environment
# }