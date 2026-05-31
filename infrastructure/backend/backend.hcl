# Remote state: S3 + DynamoDB locking
#
# Initialize with:
#   cp backend.hcl.example backend.hcl   # edit bucket/region if needed
#   terraform init -backend-config=backend.hcl

terraform {
  backend "s3" {
    bucket = "sameer-terraform-state3"
    key = "eks/terraform.tfstate"
    region = "us-east-1"
    encrypt = true

  }
}
