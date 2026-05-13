# Production Environment

Production-grade deployment with higher capacity and availability.

## Characteristics

- One NAT Gateway per Availability Zone
- `m5.large` worker nodes
- Desired node count: 6
- Separate Terraform state (`prod/terraform.tfstate`)