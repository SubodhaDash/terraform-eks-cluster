# Bastion Host IAM Role policies and permissions
resource "aws_iam_role" "bastion_role" {
  name = "${var.cluster_name}-bastion-role"

  tags = {
    Name        = "${var.cluster_name}-bastion-role"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
    Environment = var.environment
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion_role.name
}

resource "aws_iam_policy" "bastion_eks_access" {
  name = "${var.cluster_name}-bastion-eks-access-policy"

  tags = {
    Name        = "${var.cluster_name}-bastion-eks-access-policy"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
    Environment = var.environment
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:DescribeClusterVersions",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "eks:ListUpdates",
          "eks:DescribeUpdate",
          "eks:TagResource"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "iam:CreateOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider",
          "iam:ListOpenIDConnectProviders",
          "iam:TagOpenIDConnectProvider",

          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicies",
          "iam:ListPolicyVersions",

          "iam:GetRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PassRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:ListAttachedRolePolicies"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeRouteTables"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "cloudformation:CreateStack",
          "cloudformation:UpdateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStacks",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStackResources",
          "cloudformation:ListStacks",
          "cloudformation:ListStackResources",
          "cloudformation:GetTemplate",
          "cloudformation:UpdateTerminationProtection"
        ]
        Resource = "*"
      }

    ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_eks_attach" {
  policy_arn = aws_iam_policy.bastion_eks_access.arn
  role       = aws_iam_role.bastion_role.name
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${var.cluster_name}-bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
  tags = {
    Name        = "${var.cluster_name}-bastion-instance-profile"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
    Environment = var.environment
  }
}
# ##############################################################################################

# ALB Controller IAM Role policies and permissions

locals {
  oidc_hostpath = replace(var.oidc_issuer_url, "https://", "")
}

data "tls_certificate" "eks_oidc" {
  url = var.oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = var.oidc_issuer_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]

  tags = {
    Name        = "${var.cluster_name}-oidc-provider"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
    Environment = var.environment
  }
}

resource "aws_iam_policy" "alb_controller_policy" {
  name = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"

  tags = {
    Name        = "${var.cluster_name}-alb-controller-policy"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
    Environment = var.environment
  }

  policy = file("${path.module}/policies/alb-controller-policy.json")
}

resource "aws_iam_role" "alb_controller_role" {
  name = "${var.cluster_name}-AmazonEKSLoadBalancerControllerRole"

  tags = {
    Name        = "${var.cluster_name}-alb-controller-role"
    ManagedBy   = "Terraform"
    Project     = "terraform-eks-cluster"
    Environment = var.environment
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_hostpath}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
            "${local.oidc_hostpath}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  policy_arn = aws_iam_policy.alb_controller_policy.arn
  role       = aws_iam_role.alb_controller_role.name
}