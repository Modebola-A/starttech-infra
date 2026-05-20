output "alb_dns_name" {
  description = "ALB DNS name - use this as your backend API URL"
  value       = module.compute.alb_dns_name
}

output "cloudfront_domain" {
  description = "CloudFront URL - use this as your frontend URL"
  value       = module.storage.cloudfront_domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name for frontend deployment"
  value       = module.storage.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation"
  value       = module.storage.cloudfront_distribution_id
}

output "redis_endpoint" {
  description = "Redis endpoint for backend configuration"
  value       = module.monitoring.redis_endpoint
}

output "backend_log_group" {
  description = "CloudWatch log group for backend logs"
  value       = module.monitoring.backend_log_group_name
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.compute.asg_name
}
