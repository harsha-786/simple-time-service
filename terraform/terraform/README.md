
# Terraform – ECS Fargate + ALB (2 public + 2 private subnets)

This Terraform stack creates:

- **VPC** with 2 public and 2 private subnets (with NAT for egress)
- **ECS Fargate cluster** and service running your container in **private subnets only**
- **Application Load Balancer (ALB)** in public subnets exposing the service

Container used: `harsha786docker/simple-time-service:1.0.1` listening on port `8080`.

## Repository structure (recommended)
```
.
├── app           # Your application & Dockerfile (Task 1)
└── terraform     # This folder – run terraform here
```

## Prerequisites
- Terraform `>= 1.6`
- AWS credentials configured **outside the repo** (no secrets committed):
  - via AWS CLI `aws configure` (default profile), or
  - environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`
- Optional: set a specific profile using `-var aws_profile=...`

## Variables & defaults
See `variables.tf` and `terraform.tfvars` for defaults:
- `aws_region` (default: `ap-south-1`)
- `aws_profile` (default: `default`)
- `app_image` (default: `harsha786docker/simple-time-service:1.0.1`)
- `container_port` (default: `8080`)
- `desired_count` (default: `2`)
- `instance_cpu` (default: `256`)
- `instance_memory` (default: `512`)

## Usage
```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

> **Only `terraform plan` and `terraform apply` are required** to create the infra and deploy the container.

## Outputs
After apply, Terraform prints:
- `alb_dns_name` – the ALB DNS endpoint
- `service_url` – convenience URL

Test the service:
```bash
curl $(terraform output -raw service_url)
```
Expected JSON:
```json
{
  "timestamp": "<UTC time>",
  "ip": "<your IP>"
}
```

## Cleanup
```bash
terraform destroy -auto-approve
```

## Notes / Best Practices
- Tasks run in **private subnets** (no public IP); ALB in **public subnets**.
- Private subnets use **NAT gateways** to pull images from Docker Hub and send logs.
- Container is minimal and runs as **non-root** (from Task 1 image).
- No credentials are committed; authenticate via AWS CLI or env vars.

## Troubleshooting
- If ALB shows 5xx initially, wait ~1–2 minutes for ECS tasks to become **healthy** (health check path `/healthz`).
- If `terraform apply` fails on capacity/NAT/limits, ensure your AWS account has available quotas (ALB/NAT incur cost).
