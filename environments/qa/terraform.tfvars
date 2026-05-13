cluster_name              = "qa-eks-cluster"
region                    = "ap-south-2"
cluster_version           = "1.30"

enable_single_nat_gateway = true

node_groups = {
  general = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      desired_size = 3
      min_size     = 2
      max_size     = 4
    }
  }
}