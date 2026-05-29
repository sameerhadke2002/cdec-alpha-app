output "distribution_id" {
  description = "CloudFront distribution ID (used for cache invalidation and some integrations)."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN."
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "CloudFront domain name to use as an alias target in Route 53 (e.g. d111111abcdef8.cloudfront.net)."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID for CloudFront alias records (constant per region: Z2FDTNDATAQYW2)."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "distribution_domain_name" {
  description = "Same as domain_name; provided for clarity in root module wiring."
  value       = aws_cloudfront_distribution.this.domain_name
}
