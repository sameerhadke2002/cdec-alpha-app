variable "enabled" {
  description = "Whether the distribution is enabled."
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment shown in the AWS console for this distribution."
  type        = string
  default     = ""
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs) for this distribution, e.g. [\"www.example.com\"]. Requires acm_certificate_arn."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1 for custom domain names. Required when aliases is non-empty."
  type        = string
  default     = null

  validation {
    condition     = length(var.aliases) == 0 || var.acm_certificate_arn != null
    error_message = "acm_certificate_arn must be set when aliases are provided."
  }
}

variable "origin_domain_name" {
  description = "DNS name of the origin (S3 bucket regional domain name or custom origin hostname)."
  type        = string
}

variable "origin_id" {
  description = "Unique identifier for this origin within the distribution. Referenced by cache behaviors."
  type        = string
  default     = "primary"
}

variable "origin_access_control_id" {
  description = "Origin Access Control (OAC) ID for private S3 origins. Leave null for custom (non-S3) origins."
  type        = string
  default     = null
}

variable "origin_protocol_policy" {
  description = "How CloudFront connects to a custom origin when OAC is not used."
  type        = string
  default     = "https-only"

  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.origin_protocol_policy)
    error_message = "origin_protocol_policy must be http-only, https-only, or match-viewer."
  }
}

variable "default_root_object" {
  description = "Object returned for root URL requests (common for static sites), e.g. index.html."
  type        = string
  default     = "index.html"
}

variable "viewer_protocol_policy" {
  description = "Protocol policy for viewers."
  type        = string
  default     = "redirect-to-https"

  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "viewer_protocol_policy must be allow-all, https-only, or redirect-to-https."
  }
}

variable "allowed_methods" {
  description = "HTTP methods CloudFront processes for the default cache behavior."
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "HTTP methods CloudFront caches for the default cache behavior."
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cache_policy_id" {
  description = "Managed cache policy ID. Defaults to AWS CachingOptimized if null."
  type        = string
  default     = null
}

variable "compress" {
  description = "Whether CloudFront compresses objects for viewers that support it."
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class for the distribution."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "price_class must be PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "geo_restriction_type" {
  description = "Geo restriction type: none, whitelist, or blacklist."
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "ISO 3166-1-alpha-2 country codes when using whitelist or blacklist."
  type        = list(string)
  default     = []
}

variable "minimum_protocol_version" {
  description = "Minimum TLS version when using a custom ACM certificate."
  type        = string
  default     = "TLSv1.2_2021"
}

variable "tags" {
  description = "Tags applied to the CloudFront distribution."
  type        = map(string)
  default     = {}
}
