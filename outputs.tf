output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "bastion_arn" {
  description = "ARN of the bastion role"
  value       = module.iam.bastion_role_arn
}

output "alb_controller_role_arn" {
  description = "ARN of the ALB controller role"
  value       = module.iam.alb_controller_role_arn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL"
  value       = module.eks.oidc_issuer_url
}