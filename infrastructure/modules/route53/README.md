# Route 53 module

Manages **DNS**: optionally creates a hosted zone and creates records (including alias records to CloudFront).

## What this module does

- Optional new hosted zone (`create_zone = true`)
- Records in an existing or new zone via a single `records` list
- Alias records suitable for CloudFront, ALB, API Gateway, etc.

## What this module does not do

- Registrar configuration (you still point your domain to Route 53 name servers)
- Health checks or routing policies beyond simple records
- Private hosted zones (can be extended later with a variable if needed)

## Usage

### Alias record to CloudFront (existing zone)

```hcl
module "dns" {
  source = "../modules/route53"

  create_zone = false
  zone_id     = var.hosted_zone_id

  records = [
    {
      name = "www.example.com"
      type = "A"
      alias = {
        name    = module.cdn.domain_name
        zone_id = module.cdn.hosted_zone_id
      }
    },
    {
      name = "www.example.com"
      type = "AAAA"
      alias = {
        name    = module.cdn.domain_name
        zone_id = module.cdn.hosted_zone_id
      }
    },
  ]
}
```

### New hosted zone + apex alias

```hcl
module "dns" {
  source = "../modules/route53"

  create_zone = true
  zone_name   = "example.com"

  records = [
    {
      name = "example.com"
      type = "A"
      alias = {
        name    = module.cdn.domain_name
        zone_id = module.cdn.hosted_zone_id
      }
    },
  ]

  tags = var.tags
}
```

## Inputs

See [variables.tf](variables.tf). Either create a zone or supply `zone_id`.

## Outputs

| Output | Use |
|--------|-----|
| `zone_id` | Further records or outputs |
| `name_servers` | Registrar delegation (when zone is created) |
| `record_fqdns` | Verification after apply |

## Notes

- Record keys are `name-type`; duplicate name with different types (A + AAAA) is supported.
- For each record, set **either** `alias` **or** `records` (simple record values).
