variable "cluster_name" {
  description = "Name of the Amazon EKS cluster."
  type        = string

  validation {
    condition     = length(var.cluster_name) >= 3
    error_message = "cluster_name must be at least 3 characters long."
  }
}

variable "cluster_version" {
  description = "Kubernetes version for the Amazon EKS control plane."
  type        = string

  validation {
    condition     = can(regex("^1\\.[0-9]+$", var.cluster_version))
    error_message = "cluster_version must be in the format 1.xx, for example 1.30."
  }
}

variable "vpc_id" {
  description = "ID of the Amazon VPC where the EKS cluster will be deployed."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "vpc_id cannot be empty."
  }
}

variable "subnet_ids" {
  description = "List of private subnet IDs used by the EKS cluster and managed node groups."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs are recommended for high availability."
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

  validation {
    condition = alltrue([
      for ng in values(var.node_groups) :
      contains(["ON_DEMAND", "SPOT"], ng.capacity_type)
    ])
    error_message = "capacity_type must be either ON_DEMAND or SPOT."
  }
}

variable "bastion_role_arn" {
  description = "ARN of the IAM role granted EKS cluster access for the bastion host."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.bastion_role_arn))
    error_message = "bastion_role_arn must be a valid AWS IAM role ARN."
  }
}