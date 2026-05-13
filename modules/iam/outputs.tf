output "bastion_role_arn" {
  value = aws_iam_role.bastion_role.arn
}

output "bastion_instance_profile_arn" {
  value = aws_iam_instance_profile.bastion_instance_profile.arn
}

output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller_role.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}