# =============================================================================
# VPC Module Variables
# =============================================================================
# This module creates:
# - Amazon VPC
# - Public and private subnets
# - Internet Gateway
# - NAT Gateway
# - Route tables
#
# These variables are provided by the root module.
# =============================================================================

variable "vpc_cidr" {
  description = "CIDR block for the Amazon VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block, for example 10.0.0.0/16."
  }
}

variable "availability_zones" {
  description = "List of Availability Zones where subnets will be created."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are recommended for high availability."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets used by EKS worker nodes."
  type        = list(string)

  validation {
    condition = (
      length(var.private_subnet_cidrs) == length(var.availability_zones) &&
      alltrue([
        for cidr in var.private_subnet_cidrs :
        can(cidrhost(cidr, 0))
      ])
    )
    error_message = "private_subnet_cidrs must contain valid CIDR blocks and match the number of availability_zones."
  }
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets used for NAT Gateways and load balancers."
  type        = list(string)

  validation {
    condition = (
      length(var.public_subnet_cidrs) == length(var.availability_zones) &&
      alltrue([
        for cidr in var.public_subnet_cidrs :
        can(cidrhost(cidr, 0))
      ])
    )
    error_message = "public_subnet_cidrs must contain valid CIDR blocks and match the number of availability_zones."
  }
}

variable "cluster_name" {
  description = "Name of the Amazon EKS cluster used for tagging AWS resources."
  type        = string

  validation {
    condition     = length(var.cluster_name) >= 3
    error_message = "cluster_name must be at least 3 characters long."
  }
}

variable "enable_single_nat_gateway" {
  description = "Whether to create a single NAT Gateway instead of one per Availability Zone."
  type        = bool
}