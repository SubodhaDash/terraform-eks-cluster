cluster_name    = "prod-eks-cluster"
region          = "ap-south-2"
cluster_version = "1.30"
environment     = "prod"

enable_single_nat_gateway = false

node_groups = {
  general = {
    instance_types = ["m5.large"]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      desired_size = 6
      min_size     = 3
      max_size     = 10
    }
  }
}