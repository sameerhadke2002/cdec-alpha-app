# CloudFront module

Creates one **Amazon CloudFront distribution** for frontend traffic (static site or custom origin).

## What this module does

- Single origin (S3 with OAC, or custom origin such as ALB)
- Default cache behavior using the AWS **CachingOptimized** managed cache policy
- Optional custom domain names (`aliases`) with ACM certificate in **us-east-1**
- HTTPS redirect for viewers by default

## What this module does not do

- S3 buckets, bucket policies, or Origin Access Control resources (pass `origin_access_control_id` from your root module when ready)
- ACM certificate creation (create in us-east-1, pass ARN)
- WAF, Lambda@Edge, or additional cache behaviors

## Usage

### Custom origin (no S3 OAC)

```hcl
module "cdn" {
  source = "../modules/cloudfront"

  comment              = "dev frontend"
  origin_domain_name   = "my-origin.example.com"
  origin_id            = "primary"
  origin_protocol_policy = "https-only"
  tags = {
    Environment = "dev"
    Application = "cdec-frontend"
  }
}
```

### S3 origin with Origin Access Control

```hcl
module "cdn" {
  source = "../modules/cloudfront"

  origin_domain_name         = aws_s3_bucket.site.bucket_regional_domain_name
  origin_access_control_id   = aws_cloudfront_origin_access_control.site.id
  aliases                    = ["www.example.com"]
  acm_certificate_arn        = var.acm_certificate_arn
  tags                       = var.tags
}
```

## Inputs

See [variables.tf](variables.tf) for the full list. Required input: `origin_domain_name`.

## Outputs

| Output | Use |
|--------|-----|
| `domain_name` | Alias target for Route 53 |
| `hosted_zone_id` | Alias zone ID for Route 53 (from CloudFront) |
| `distribution_id` | Cache invalidation |

## Notes

- ACM certificates for CloudFront must be in **us-east-1**, regardless of where you run Terraform.
- Pair with the [Route53 module](../route53/README.md) using `domain_name` and `hosted_zone_id` outputs.
