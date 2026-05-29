# Backend stack

Terraform root for backend infrastructure: **VPC** then **EKS**. Shared modules live in [`../modules/`](../modules/).

## Layout

```text
backend/
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
| State key | `backend/terraform.tfstate` |
| Example bucket | `cdec-alpha-terraform-state` |

```bash
cd infrastructure/backend
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config=backend.hcl
terraform plan
```

## Module wiring

```text
module "vpc"  →  ../modules/vpc
module "eks"  →  ../modules/eks   (uses vpc outputs)
```

## Jenkins

**Script path:** `infrastructure/backend/Jenkinsfile`

1. AWS credential: `aws-backend-terraform`
2. On the agent, add `terraform.tfvars` and `backend.hcl` (from the `.example` files)

## Application pairing

API / services source: [`application/backend/`](../../application/backend/README.md).
