variable "bastion_ami_name" {
  description = "Name of the AMI to use for the bastion host"
  type = string
}

variable "key_pair_name" {
  description = "Name of the key pair to use for the bastion host"
  type = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type = string
}

variable "bastion_subnet_id" {
  description = "Subnet ID for the bastion host"
  type = string
}

variable "bastion_sg_id" {
  description = "Security group ID for the bastion host"
  type = string
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type = string
}

variable "bastion_instance_profile" {
  description = "IAM instance profile for the bastion host"
  type = string
}

variable "repo_url" {
  description = "URL of the Git repository to clone on the bastion host"
  type = string
}