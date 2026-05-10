variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_issuer_url" {
  description = "Unique oidc url of the cluster"
  type       = string
}

variable "namespace" {
  type = string
  description = "Namespace of ALB Controller"
}

variable "service_account_name" {
  type = string
  description = "Name of the service account for ALB Controller"
}