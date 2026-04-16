output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private_subnet[*].id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public_subnet[*].id
}

output "bastion_sg_id" {
  description = "Bastion SG Id"
  value       = aws_security_group.bastion_sg.id
}