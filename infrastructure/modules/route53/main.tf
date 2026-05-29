resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0
  name  = var.zone_name
  tags  = var.tags
}

locals {
  zone_id = var.create_zone ? aws_route53_zone.this[0].zone_id : var.zone_id
}

resource "aws_route53_record" "this" {
  for_each = {
    for record in var.records : "${record.name}-${record.type}" => record
  }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type

  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  ttl     = each.value.alias != null ? null : each.value.ttl
  records = each.value.alias != null ? null : each.value.records
}
