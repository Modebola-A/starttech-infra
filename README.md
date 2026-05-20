# StartTech Infrastructure

This repository contains the Infrastructure as Code (IaC) for the StartTech application, managed with Terraform and deployed via GitHub Actions CI/CD pipeline.

## Architecture Overview

- **Frontend**: React app hosted on S3, served via CloudFront CDN
- **Backend**: Golang API running on EC2 instances behind an Application Load Balancer
- **Cache**: ElastiCache Redis for session management and caching
- **Database**: MongoDB Atlas for data persistence
- **Infrastructure**: All managed with Terraform on AWS (eu-west-2)

## Repository Structure
starttech-infra/
├── .github/workflows/
│   └── infrastructure-deploy.yml  # Terraform CI/CD pipeline
├── terraform/
│   ├── main.tf                    # Root module
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   ├── terraform.tfvars.example   # Example variables
│   └── modules/
│       ├── networking/            # VPC, subnets, security groups
│       ├── compute/               # EC2, ASG, ALB, IAM
│       ├── storage/               # S3, CloudFront
│       └── monitoring/            # ElastiCache, CloudWatch
├── scripts/
│   └── deploy-infrastructure.sh  # Manual deployment script
├── monitoring/
│   ├── cloudwatch-dashboard.json  # Dashboard definition
│   ├── alarm-definitions.json     # Alarm configurations
│   └── log-insights-queries.txt   # Useful log queries
└── README.md

## Prerequisites

- Terraform >= 1.7.0
- AWS CLI configured with appropriate permissions
- AWS Account with eu-west-2 region enabled

## Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/Modebola-A/starttech-infra.git
cd starttech-infra
```

### 2. Configure variables
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform.tfvars with your values
```

### 3. Deploy infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## GitHub Actions Pipeline

The infrastructure pipeline runs automatically on push to `main` when files in `terraform/` change:
- **Pull Request**: runs `terraform plan` only
- **Push to main**: runs `terraform plan` then `terraform apply`

### Required GitHub Secrets
| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM user secret key |

## Infrastructure Components

### Networking
- VPC with CIDR `10.0.0.0/16`
- 2 public subnets (eu-west-2a, eu-west-2b)
- 2 private subnets (eu-west-2a, eu-west-2b)
- Internet Gateway and route tables
- Security groups for ALB, EC2, and Redis

### Compute
- Application Load Balancer (public-facing)
- Auto Scaling Group (min: 1, desired: 2, max: 4)
- EC2 t3.micro instances (Ubuntu 22.04)
- IAM role with CloudWatch and ECR permissions
- CPU-based scaling policies (scale up >70%, scale down <20%)

### Storage
- S3 bucket for React static files
- CloudFront distribution with HTTPS redirect
- Origin Access Control (OAC) for secure S3 access

### Monitoring
- ElastiCache Redis cluster (cache.t3.micro)
- CloudWatch Log Groups for backend and frontend
- CloudWatch Dashboard with CPU, ALB, and Redis metrics
- CloudWatch Alarms for high CPU, low CPU, 5xx errors, Redis memory

## Outputs

After `terraform apply`, the following values are available:
| Output | Description |
|--------|-------------|
| `alb_dns_name` | Backend API URL |
| `cloudfront_domain` | Frontend URL |
| `s3_bucket_name` | S3 bucket for frontend deployment |
| `cloudfront_distribution_id` | For cache invalidation |
| `redis_endpoint` | Redis connection endpoint |

## Security

- S3 bucket is private, accessible only via CloudFront
- EC2 instances only accept traffic from ALB on port 8080
- Redis only accepts traffic from EC2 instances
- IAM roles follow least-privilege principle
- All secrets managed via GitHub Actions secrets