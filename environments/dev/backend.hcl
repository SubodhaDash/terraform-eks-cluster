bucket         = "subodha-demo-terraform-eks-state-bucket"
key            = "dev/terraform.tfstate"
region         = "ap-south-2"
dynamodb_table = "terraform-eks-state-locks"
encrypt        = true