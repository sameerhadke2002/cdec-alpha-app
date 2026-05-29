variable "aws_region" {
  description = "AWS region for Route 53 and regional resources. ACM for CloudFront must be in us-east-1."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name used in tags and naming."
  type        = string
  default     = "dev"
}

variable "application" {
  description = "Application identifier for default tags."
  type        = string
  default     = "cdec-frontend"
}

variable "origin_domain_name" {
  description = "Origin hostname for CloudFront (S3 regional domain or custom origin)."
  type        = string
}

variable "origin_access_control_id" {
  description = "OAC ID when using a private S3 origin. Leave null for custom origins."
  type        = string
  default     = null
}

variable "cloudfront_aliases" {
  description = "Custom domain names for the distribution. Leave empty to use the default cloudfront.net hostname."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1. Required if cloudfront_aliases is non-empty."
  type        = string
  default     = null
}

variable "create_dns_zone" {
  description = "If true, creates a Route 53 hosted zone. If false, set route53_zone_id."
  type        = bool
  default     = false
}

variable "dns_zone_name" {
  description = "Zone name when create_dns_zone is true, e.g. example.com."
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "Existing hosted zone ID when create_dns_zone is false."
  type        = string
  default     = null
}

variable "dns_record_name" {
  description = "FQDN for alias records to CloudFront (e.g. www.example.com). Leave empty to skip DNS records."
  type        = string
  default     = ""
}
