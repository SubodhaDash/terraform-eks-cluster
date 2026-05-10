output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "oidc_issuer_url" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}