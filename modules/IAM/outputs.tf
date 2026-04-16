output "bastion_role_arn" {
  value = aws_iam_role.bastion_role.arn
}

output "bastion_instance_profile_arn" {
  value = aws_iam_instance_profile.bastion_instance_profile.arn
}