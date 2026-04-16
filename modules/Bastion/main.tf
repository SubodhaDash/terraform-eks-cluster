data "aws_ami" "bastion" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.bastion_ami_name]
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.bastion.id
  instance_type = var.bastion_instance_type
  subnet_id     = var.bastion_subnet_id
  security_groups = [var.bastion_sg_id]
  iam_instance_profile = var.bastion_instance_profile

  key_name = var.key_pair_name

  associate_public_ip_address = true

  user_data = templatefile("${path.module}/bastion_user_data.sh", {
    repo_url = var.repo_url
  })

  tags = {
    Name = "${var.cluster_name}-bastion-host"
  }
}