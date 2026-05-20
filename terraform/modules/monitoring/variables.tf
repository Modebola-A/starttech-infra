variable "project_name"          { type = string }
variable "environment"           { type = string }
variable "aws_region"            { type = string }
variable "private_subnet_ids"    { type = list(string) }
variable "redis_security_group_id" { type = string }
variable "alb_arn_suffix"        { type = string }
