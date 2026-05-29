output "zone_id" {
  description = "Hosted zone ID (created or supplied)."
  value       = local.zone_id
}

output "zone_name" {
  description = "Hosted zone name when this module created the zone; otherwise null."
  value       = var.create_zone ? aws_route53_zone.this[0].name : null
}

output "name_servers" {
  description = "Delegation name servers when this module created the zone. Configure these at your domain registrar."
  value       = var.create_zone ? aws_route53_zone.this[0].name_servers : null
}

output "record_fqdns" {
  description = "Map of record keys (name-type) to FQDN."
  value       = { for key, record in aws_route53_record.this : key => record.fqdn }
}
