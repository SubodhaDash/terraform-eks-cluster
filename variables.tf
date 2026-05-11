# =============================================================================
# Root Variables for Terraform EKS Cluster
# =============================================================================
# This file defines all configurable inputs for the project:
# - VPC and networking configuration
# - EKS cluster configuration
# - Bastion host configuration
# - IAM and IRSA configuration

# =============================================================================
# VPC Variables
# =============================================================================

variable "region" {
  description = "AWS region where all infrastructure resources will be created."
  type        = string
  default     = "ap-south-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "Provide a valid AWS region, for example ap-south-2."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the Amazon VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block, for example 10.0.0.0/16."
  }
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All public_subnet_cidrs values must be valid CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  validation {
    condition     = alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All private_subnet_cidrs values must be valid CIDR blocks."
  }
}

variable "availability_zones" {
  description = "List of Availability Zones where subnets and nodes will be deployed."
  type        = list(string)
  default     = ["ap-south-2a", "ap-south-2b", "ap-south-2c"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are recommended."
  }
}

variable "cluster_name" {
  description = "Name of the Amazon EKS cluster."
  type        = string
  default     = "subodha-eks-cluster"

  validation {
    condition     = length(var.cluster_name) >= 3
    error_message = "cluster_name must be at least 3 characters long."
  }
}

variable "enable_single_nat_gateway" {
  description = "Whether to use a single NAT Gateway to reduce AWS costs."
  type        = bool
  default     = true
}

# =============================================================================
# EKS Variables
# =============================================================================

variable "cluster_version" {
  description = "Kubernetes version to use for the Amazon EKS control plane."
  type        = string
  default     = "1.30"

  validation {
    condition     = can(regex("^1\\.[0-9]+$", var.cluster_version))
    error_message = "cluster_version must be in the format 1.xx, for example 1.30."
  }
}

variable "node_groups" {
  description = "Map of Amazon EKS managed node group configurations."

  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))

  default = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 3
        max_size     = 4
        min_size     = 1
      }
    }
  }

  validation {
    condition = alltrue([
      for ng in values(var.node_groups) :
      contains(["ON_DEMAND", "SPOT"], ng.capacity_type)
    ])
    error_message = "capacity_type must be either ON_DEMAND or SPOT."
  }
}

# =============================================================================
# Bastion Host Variables
# =============================================================================

variable "bastion_ami_name" {
  description = "AMI name filter used to locate the Ubuntu image for the bastion host."
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251022"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host."
  type        = string
  default     = "t3.large"
}

variable "bastion_key_pair_name" {
  description = "Name of the existing AWS EC2 key pair used to access the bastion host."
  type        = string
  default     = "devops-demo"
}

variable "bastion_repo_url" {
  description = "Git repository URL that will be cloned on the bastion host."
  type        = string
  default     = "git@github.com:SubodhaDash/opentelemery-demo-project.git"
}

# =============================================================================
# IAM / IRSA Variables
# =============================================================================

variable "service_account_name" {
  description = "Kubernetes service account name used by AWS Load Balancer Controller."
  type        = string
  default     = "aws-load-balancer-controller"

  validation {
    condition     = length(var.service_account_name) > 0
    error_message = "service_account_name cannot be empty."
  }
}

variable "namespace" {
  description = "Kubernetes namespace where AWS Load Balancer Controller will be deployed."
  type        = string
  default     = "kube-system"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}