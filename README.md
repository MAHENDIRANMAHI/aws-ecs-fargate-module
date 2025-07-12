# AWS ECS Fargate Terraform Modules

This directory contains reusable Terraform modules for deploying AWS infrastructure components using ECS with Fargate. Each module is designed to be DRY, flexible, and environment-agnostic.

## Modules

- **ecr/**: Creates ECR repositories. Supports dynamic creation with `for_each` and custom tags.
- **vpc/**: Creates a VPC with configurable subnets.
- **ecs_cluster/**: Provisions an ECS cluster.
- **ecs_task_definition/**: Defines ECS task definitions.
- **ecs_fargate_service/**: Deploys ECS Fargate services.

## Usage Example

```hcl
module "ecr" {
  source   = "../module/ecr"
  for_each = var.ecr_repositories
  name     = each.value.name
  tags     = each.value.tags
}

module "vpc_main" {
  source          = "../module/vpc"
  name            = var.project
  cidr_block      = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  environment     = var.environment
  project         = var.project
}

# ...other modules as needed
```

## Inputs
- All modules use variables for configuration. See each module's `variables.tf` for details.

## Outputs
- Each module provides useful outputs (e.g., ECR repo URL/ARN, VPC IDs, ECS cluster ID, etc.).

## Best Practices
- Use environment-specific `.tfvars` files for values.
- Reference modules with correct relative paths (e.g., `../module/vpc`).
- Use `for_each` for dynamic resource creation (e.g., ECR repos).

## Example Structure
```
terraform/
  main.tf
  variables.tf
  staging.tfvars
  prod.tfvars
module/
  ecr/
  vpc/
  ecs_cluster/
  ecs_task_definition/
  ecs_fargate_service/
```

---

For more details, see each module's README or `variables.tf`.
