# =============================================================================
# IAM Module Variables
# =============================================================================
# This module creates:
# - EKS OIDC provider
# - IAM policy for AWS Load Balancer Controller
# - IAM role for IRSA
#
# These variables are provided by the root module.
# =============================================================================

variable "cluster_name" {
  description = "Name of the Amazon EKS cluster used to construct IAM resource names."
  type        = string

  validation {
    condition     = length(var.cluster_name) >= 3
    error_message = "cluster_name must be at least 3 characters long."
  }
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL of the Amazon EKS cluster used to configure IAM Roles for Service Accounts (IRSA)."
  type        = string

  validation {
    condition     = can(regex("^https://", var.oidc_issuer_url))
    error_message = "oidc_issuer_url must start with https://."
  }
}

variable "namespace" {
  description = "Kubernetes namespace where AWS Load Balancer Controller will be deployed."
  type        = string

  validation {
    condition     = length(trim(var.namespace, " ")) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "service_account_name" {
  description = "Kubernetes service account name used by AWS Load Balancer Controller."
  type        = string

  validation {
    condition     = length(trim(var.service_account_name, " ")) > 0
    error_message = "service_account_name cannot be empty."
  }
}