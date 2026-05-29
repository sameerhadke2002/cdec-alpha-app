# AWS managed policy: CachingOptimized (recommended default for static content)
locals {
  default_cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  is_ipv6_enabled     = true
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class
  aliases             = var.aliases
  tags                = var.tags

  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id

    origin_access_control_id = var.origin_access_control_id

    # Custom origins (ALB, API, non-OAC setups) use custom_origin_config.
    # S3 with OAC sets origin_access_control_id and omits this block.
    dynamic "custom_origin_config" {
      for_each = var.origin_access_control_id == null ? [1] : []
      content {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = var.origin_protocol_policy
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior {
    target_origin_id       = var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    compress               = var.compress
    cache_policy_id        = coalesce(var.cache_policy_id, local.default_cache_policy_id)
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  dynamic "viewer_certificate" {
    for_each = length(var.aliases) > 0 ? [1] : []
    content {
      acm_certificate_arn      = var.acm_certificate_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = var.minimum_protocol_version
    }
  }

  dynamic "viewer_certificate" {
    for_each = length(var.aliases) == 0 ? [1] : []
    content {
      cloudfront_default_certificate = true
    }
  }
}
