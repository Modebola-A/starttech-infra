# Operations Runbook

## Deployments

### Deploy Frontend Manually
```bash
cd much-to-do
./scripts/deploy-frontend.sh starttech-frontend-prod-106143 E1QM9G6ELHAAXD
```

### Deploy Backend Manually
```bash
cd much-to-do
./scripts/deploy-backend.sh <image-tag> starttech-asg
```

### Deploy Infrastructure Manually
```bash
cd starttech-infra
./scripts/deploy-infrastructure.sh apply
```

## Health Checks

### Check backend health
```bash
curl http://starttech-alb-1836606467.eu-west-2.elb.amazonaws.com/health
```

### Run health check script
```bash
./scripts/health-check.sh starttech-alb-1836606467.eu-west-2.elb.amazonaws.com
```

### Check ASG instance health
```bash
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names starttech-asg \
  --region eu-west-2
```

## Rollback Procedures

### Rollback backend to previous version
```bash
./scripts/rollback.sh starttech-asg <previous-image-tag>
```

### Rollback infrastructure
```bash
cd starttech-infra/terraform
terraform apply -target=<resource> -auto-approve
```

## Troubleshooting

### Backend instances not healthy in ALB
1. Check EC2 instance logs in CloudWatch: `/starttech/backend`
2. Verify security group allows ALB to reach port 8080
3. Check Docker container is running: `docker ps`
4. Verify `/health` endpoint returns 200

### Frontend not updating after deployment
1. Check S3 sync completed successfully in GitHub Actions
2. Verify CloudFront invalidation completed
3. Clear browser cache and retry

### Redis connection errors
1. Check ElastiCache cluster status in AWS Console
2. Verify EC2 security group allows port 6379 to Redis
3. Check Redis endpoint in application environment variables

### High CPU alarm triggered
1. Check CloudWatch dashboard for traffic spike
2. ASG should auto-scale — verify in EC2 → Auto Scaling Groups
3. If not scaling, check scaling policies are attached

## Useful CloudWatch Log Queries

### View recent errors
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 50

### Check request rate
fields @timestamp
| stats count() as requests by bin(1m)
| sort @timestamp desc

## Key Resource IDs

| Resource | Value |
|----------|-------|
| ALB DNS | starttech-alb-1836606467.eu-west-2.elb.amazonaws.com |
| CloudFront ID | E1QM9G6ELHAAXD |
| CloudFront Domain | dqaf2c5baahft.cloudfront.net |
| S3 Bucket | starttech-frontend-prod-106143 |
| Redis Endpoint | starttech-redis.khsdc3.0001.euw2.cache.amazonaws.com |
| ASG Name | starttech-asg |
| Region | eu-west-2 |