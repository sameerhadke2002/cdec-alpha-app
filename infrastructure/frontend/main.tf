# Frontend stack — composes shared modules from infrastructure/modules/

module "cloudfront" {
  source = "../modules/cloudfront"

  comment            = "${var.application}-${var.environment}"
  origin_domain_name = var.origin_domain_name
  origin_id          = "primary"

  origin_access_control_id = var.origin_access_control_id
  aliases                  = var.cloudfront_aliases
  acm_certificate_arn      = var.acm_certificate_arn

  tags = {
    Component = "cloudfront"
  }
}

module "route53" {
  source = "../modules/route53"

  create_zone = var.create_dns_zone
  zone_name   = var.dns_zone_name
  zone_id     = var.route53_zone_id

  records = var.dns_record_name != "" ? [
    {
      name = var.dns_record_name
      type = "A"
      alias = {
        name    = module.cloudfront.domain_name
        zone_id = module.cloudfront.hosted_zone_id
      }
    },
    {
      name = var.dns_record_name
      type = "AAAA"
      alias = {
        name    = module.cloudfront.domain_name
        zone_id = module.cloudfront.hosted_zone_id
      }
    },
  ] : []

  tags = {
    Component = "route53"
  }
}
