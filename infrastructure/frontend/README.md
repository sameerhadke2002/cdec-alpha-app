# Frontend stack

Terraform root for the frontend (CloudFront + Route 53). Calls shared modules in [`../modules/`](../modules/).

## Layout

```text
frontend/
├── Jenkinsfile
├── backend.tf              # S3 remote state (partial config)
├── backend.hcl.example       # Copy to backend.hcl (gitignored)
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── terraform.tfvars.example
```

## Remote state

State is stored in **S3** with **DynamoDB** locking. See [`../REMOTE_STATE.md`](../REMOTE_STATE.md).

| Setting | Value |
|---------|--------|
| State key | `frontend/terraform.tfstate` |
| Example bucket | `cdec-alpha-terraform-state` |

```bash
cd infrastructure/frontend
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config=backend.hcl
terraform plan
```

## Module sources

```hcl
module "cloudfront" { source = "../modules/cloudfront" }
module "route53"   { source = "../modules/route53" }
```

## Jenkins

**Script path:** `infrastructure/frontend/Jenkinsfile`

1. AWS credential: `aws-frontend-terraform`
2. On the agent, add `terraform.tfvars` and `backend.hcl` (from the `.example` files)

## Application pairing

UI source: [`application/frontend/`](../../application/frontend/README.md).
