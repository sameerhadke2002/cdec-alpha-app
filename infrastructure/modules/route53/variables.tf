variable "create_zone" {
  description = "If true, creates a new Route 53 hosted zone. If false, provide zone_id for an existing zone."
  type        = bool
  default     = false
}

variable "zone_name" {
  description = "DNS zone name with trailing dot optional (e.g. example.com). Required when create_zone is true."
  type        = string
  default     = null

  validation {
    condition     = !var.create_zone || (var.zone_name != null && var.zone_name != "")
    error_message = "zone_name is required when create_zone is true."
  }
}

variable "zone_id" {
  description = "Existing hosted zone ID. Required when create_zone is false and records are managed."
  type        = string
  default     = null

  validation {
    condition     = var.create_zone || var.zone_id != null || length(var.records) == 0
    error_message = "zone_id is required when create_zone is false and records are defined."
  }
}

variable "records" {
  description = <<-EOT
    DNS records to create. For CloudFront, use an alias record with the distribution domain_name and hosted_zone_id outputs.
    Each list entry must set either `alias` or `records` (for simple CNAME/TXT records).
  EOT
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    records = optional(list(string))
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, false)
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags applied to the hosted zone when create_zone is true."
  type        = map(string)
  default     = {}
}
