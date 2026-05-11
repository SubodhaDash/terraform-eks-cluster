# terraform-eks-cluster

# Terraform EKS Cluster on AWS

A production-ready Terraform project to provision an Amazon EKS cluster on AWS with custom VPC networking, managed node groups, IAM roles, IRSA for AWS Load Balancer Controller, and remote state management using S3 and DynamoDB.

---

## 🚀 Features

- Custom VPC with public and private subnets across multiple Availability Zones
- Single NAT Gateway for cost optimization
- Amazon EKS cluster (Kubernetes v1.30)
- Managed Node Group using `t3.medium` instances
- Auto Scaling configuration:
  - Desired Capacity: 3
  - Minimum Capacity: 1
  - Maximum Capacity: 4
- IAM roles and policies for EKS and worker nodes
- OIDC provider and IRSA for AWS Load Balancer Controller
- Remote state backend using S3 and DynamoDB
- Modular Terraform architecture
- Designed to be reusable and easy to customize

---

## 🏗️ Architecture Overview

This project provisions the following AWS resources:

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- EKS Cluster
- Managed Node Group
- IAM Roles and Policies
- OIDC Provider
- AWS Load Balancer Controller IAM Role
- S3 Bucket (Terraform State)
- DynamoDB Table (State Locking)

---

## 📁 Repository Structure

```text
terraform-eks-cluster/
├── backend/
│   └── main.tf
├── modules/
│   ├── VPC/
│   ├── EKS/
│   └── IAM/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

## 🛠️ Prerequisites

Before using this project, ensure the following tools are installed:

- Terraform >= 1.5
- AWS CLI >= 2.x
- kubectl
- Git

You also need:

- An AWS account with appropriate IAM permissions
- Configured AWS credentials (`aws configure`)

---

## 🌍 Default Configuration

| Parameter | Value |
|----------|------|
| AWS Region | `ap-south-2` (Hyderabad) |
| Kubernetes Version | `1.30` |
| Instance Type | `t3.medium` |
| Desired Nodes | `3` |
| Minimum Nodes | `1` |
| Maximum Nodes | `4` |
| NAT Gateway | Single NAT Gateway |
| Remote State | S3 + DynamoDB |

---

## 🔐 Remote State Backend Setup

Before deploying the EKS cluster, create the backend infrastructure:

```bash
cd backend
terraform init
terraform apply
```

This creates:

- S3 bucket for Terraform state
- DynamoDB table for state locking

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/SubodhaDash/terraform-eks-cluster.git
cd terraform-eks-cluster
```

### 2. Create Terraform Variables File

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update values as required.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

---

## ⚙️ Example `terraform.tfvars`

```hcl
region               = "ap-south-2"
cluster_name         = "demo-eks-cluster"
kubernetes_version   = "1.30"

node_instance_type   = "t3.medium"

desired_size         = 3
min_size             = 1
max_size             = 4
```

---

## 📤 Outputs

After deployment, Terraform will output:

- EKS Cluster Name
- EKS Cluster Endpoint
- VPC ID
- Private Subnet IDs
- Public Subnet IDs
- IAM Role ARNs
- OIDC Provider ARN

---

## 🔧 Configure kubectl

After deployment, configure `kubectl`:

```bash
aws eks update-kubeconfig \
  --region ap-south-2 \
  --name demo-eks-cluster
```

Verify the cluster:

```bash
kubectl get nodes
```

---

## 🌐 AWS Load Balancer Controller (IRSA)

This project provisions:

- EKS OIDC Provider
- IAM Policy for AWS Load Balancer Controller
- IAM Role for Kubernetes Service Account

This follows AWS best practices for secure pod-level IAM access.

---

## 💰 Estimated Monthly Cost

Approximate AWS cost for a lab environment:

| Resource | Estimated Cost |
|--------|---------------|
| EKS Control Plane | ~$73/month |
| 3 × t3.medium EC2 | ~$90/month |
| NAT Gateway (Single) | ~$32/month + data processing |
| S3/DynamoDB | Minimal |

> **Estimated Total:** ~$190–$220/month depending on usage.

> **Important:** Destroy resources when not in use to avoid unnecessary charges.

---

## 🧹 Cleanup

To remove all resources:

```bash
terraform destroy
```

To remove backend resources:

```bash
cd backend
terraform destroy
```

---

## 🐛 Troubleshooting

### Terraform State Lock Error

```bash
terraform force-unlock LOCK_ID
```

### kubectl Authentication Error

```bash
aws eks update-kubeconfig --region ap-south-2 --name demo-eks-cluster
```

### Node Group Not Joining

Check:

- IAM roles
- Security groups
- Private subnet routes
- NAT Gateway connectivity

---

## 📈 Resume Highlights

- Developed a modular Terraform framework to provision production-ready Amazon EKS clusters.
- Implemented custom VPC networking with public/private subnets and NAT Gateway.
- Configured IAM roles, OIDC provider, and IRSA for AWS Load Balancer Controller.
- Enabled remote state management using S3 and DynamoDB.

---

## 🔮 Future Enhancements

- GitHub Actions for automated Terraform validation
- Bastion host using AWS Systems Manager Session Manager
- Cluster Autoscaler
- Metrics Server
- Monitoring with Prometheus and Grafana
- Multi-environment support (dev, qa, prod)

---

## 👨‍💻 Author

**Subodha Dash**

- GitHub: https://github.com/SubodhaDash
- LinkedIn: Add your LinkedIn profile URL here

---

## 📄 License

This project is licensed under the MIT License.