# AWS Terraform Multi-Environment Infrastructure

A production-style AWS setup built with Terraform modules, a dev environment, and remote state in S3.

## What it builds (30 resources in dev)
- **Network:** VPC across 3 availability zones in ap-south-1, public and private subnets, internet gateway, NAT gateway
- **Security:** IAM role with least-privilege access to one secret, security groups for the load balancer and the app
- **Load balancer:** Application Load Balancer, target group, HTTP listener
- **Compute:** launch template, Auto Scaling Group (min 1, desired 2, max 4), CPU target-tracking policy at 60%, small demo web app with a health check

## Project structure
```
modules/
  backend-bootstrap/   S3 state bucket and lock table (run once)
  network/
  security/
  alb/
  compute/
envs/
  dev/                 dev environment, calls the modules
```
Modules are reusable recipes. Each environment folder has its own state file.

## Remote state
- State stored in S3 with versioning and encryption
- State locking with `use_lockfile = true` (needs Terraform 1.10 or later)
- State key: `envs/dev/terraform.tfstate`

## How to run
1. Apply `modules/backend-bootstrap` once to create the state bucket.
2. Create `envs/dev/terraform.tfvars` (not committed to Git) with your region, app port and secret ARN.
3. Then:
```
cd envs/dev
terraform init
terraform plan
terraform apply
terraform destroy   # when finished, to avoid cost
```

## What I practised
- Remote state and state locking with two terminals (lock error shown)
- Drift: deleted the load balancer listener by hand, then plan showed 1 to add and apply fixed it
- Import: brought a hand-made S3 bucket under Terraform with `terraform import`
- Cost control: destroyed the stack after every session (NAT gateway and load balancer are the costly parts)

## Problems I faced and how I fixed them
| Problem | Fix |
|---|---|
| State bucket name with capital letters was rejected | S3 names must be lowercase |
| New instances were killed before they were ready | Raised the health check grace period from 60 to 120 seconds |
| `Module not installed` after enabling a module | Ran `terraform init` again |
| Required secret variable blocked plan while security was off | Used a temporary placeholder, then the real ARN before applying security |
| Git push asked for a password after a VS Code update | Restarted VS Code, then used a GitHub token |

## Next improvements
- Golden AMI built with Packer
- A prod environment
- CI/CD pipeline with OIDC (no stored keys)