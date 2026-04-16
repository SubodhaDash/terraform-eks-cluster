resource "aws_iam_role" "bastion_role" {
  name = "${var.cluster_name}-bastion-role"

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
}