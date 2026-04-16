variable "region" {
  description = "AWS region to deploy the EKS cluster"
  type        = string
  default     = "ap-south-2"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-south-2a", "ap-south-2b", "ap-south-2c"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "subodha-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "node_groups" {
  description = "Map of EKS node group configurations"
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
        desired_size = 2
        max_size     = 4
        min_size     = 1
      }
    }
  }

}

variable "bastion_ami_name" {
  description = "Name of the AMI to use for the bastion host"
  type = string
  default = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251022"
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type = string
  default = "t3.large"
}

variable "bastion_key_pair_name" {
  description = "Name of the key pair to use for the bastion host"
  type = string
  default = "devops-demo"
}

variable "bastion_repo_url" {
  description = "URL of the Git repository to clone on the bastion host"
  type = string
  default = "git@github.com:SubodhaDash/opentelemery-demo-project.git"
}