
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  tags = {
    Name      = "${var.cluster_name}-cluster-role"
    ManagedBy = "Terraform"
    Project   = "terraform-eks-cluster"
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  # Modern EKS access management
  access_config {
    authentication_mode = "API"
  }

  # Enable control plane logs for observability and auditing
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator"
  ]

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Resource tags for cost allocation and identification
  tags = {
    Name        = var.cluster_name
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node-role"

  tags = {
    Name      = "${var.cluster_name}-node-role"
    ManagedBy = "Terraform"
    Project   = "terraform-eks-cluster"
  }

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ])

  policy_arn = each.value
  role       = aws_iam_role.node.name
}

resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  # Safe rolling updates
  update_config {
    max_unavailable = 1
  }

  # Resource tags
  tags = {
    Name        = "${var.cluster_name}-${each.key}"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy,
  ]
}

resource "aws_eks_access_entry" "bastion_role" {
  cluster_name  = var.cluster_name
  principal_arn = var.bastion_role_arn
  type          = "STANDARD"

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_access_policy_association" "bastion_role" {
  cluster_name  = var.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.bastion_role_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_cluster.main]
}