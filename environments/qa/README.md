# QA Environment

Environment used for integration and validation testing.

## Characteristics

- Single NAT Gateway enabled
- `t3.medium` worker nodes
- Desired node count: 3
- Separate Terraform state (`qa/terraform.tfstate`)