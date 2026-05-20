# System Architecture

## High-Level Architecture
Internet
│
├──► CloudFront (CDN) ──► S3 (React Frontend)
│
└──► ALB (Load Balancer)
│
┌────┴────┐
│   ASG   │
│ EC2 #1  │──► ElastiCache Redis
│ EC2 #2  │──► MongoDB Atlas
└─────────┘
│
CloudWatch
(Logs & Metrics)

## Component Details

### Frontend Layer
- **S3 Bucket**: Stores compiled React static files
- **CloudFront**: Global CDN with HTTPS, caches static assets
- **Cache Strategy**: index.html has no-cache, assets cached for 1 year

### Backend Layer
- **ALB**: Distributes traffic across EC2 instances, runs health checks on `/health`
- **ASG**: Maintains 2 instances, scales between 1-4 based on CPU
- **EC2**: Runs Golang API in Docker container, Ubuntu 22.04, t3.micro
- **ECR**: Stores Docker images for backend deployment

### Data Layer
- **MongoDB Atlas**: Primary database for users and tasks (eu-west-1)
- **ElastiCache Redis**: Session storage and API response caching (eu-west-2)

### Networking
VPC (10.0.0.0/16)
├── Public Subnet A (10.0.1.0/24)  - ALB, EC2
├── Public Subnet B (10.0.2.0/24)  - ALB, EC2
├── Private Subnet A (10.0.10.0/24) - Redis
└── Private Subnet B (10.0.11.0/24) - Redis

### Security Groups
| Component | Inbound | Outbound |
|-----------|---------|----------|
| ALB | 80, 443 from 0.0.0.0/0 | All |
| EC2 | 8080 from ALB only, 22 | All |
| Redis | 6379 from EC2 only | All |

## CI/CD Architecture
Developer pushes code
│
▼
GitHub Actions triggered
│
┌────┴────┐
│ Frontend │    npm ci → lint → build → S3 sync → CF invalidate
│ Pipeline │
└─────────┘
│
┌────┴────┐
│ Backend  │    go test → docker build → ECR push → SSM deploy
│ Pipeline │
└─────────┘
│
┌────┴────┐
│  Infra  │    terraform init → plan → apply
│ Pipeline │
└─────────┘

## Monitoring Architecture

- **CloudWatch Logs**: EC2 instances ship logs via awslogsd agent
- **CloudWatch Metrics**: CPU, ALB requests, Redis memory
- **Alarms**: Auto-scaling triggers + notification alarms
- **Dashboard**: Centralised view of all metrics
