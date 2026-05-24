# compliant-gcs-bucket

A reusable Terraform module that deploys a compliant GCS bucket with a
customer-managed encryption key (CMEK). Compliance controls are hardcoded
inside the module — consumers cannot disable them.

## Controls enforced

| NIST 800-53 | Control Title | Implementation |
|-------------|--------------|----------------|
| SC-12 | Cryptographic Key Establishment | Customer-owned KMS keyring + crypto key |
| SC-13 | Cryptographic Protection | AES-256 CMEK, 90-day key rotation |
| SC-28 | Protection of Information at Rest | CMEK applied as bucket default encryption |
| AC-3 | Access Enforcement | Uniform bucket access + public_access_prevention = enforced |
| AU-11 | Retention | Configurable retention_days; prod requires >= 365 |
| CM-6 | Configuration Settings | Required labels enforced via module locals |

## Usage

```hcl
module "data_bucket" {
  source = "../../modules/compliant-gcs-bucket"

  gcp_project        = "your-gcp-project"
  project_label      = "cgep-lab"
  environment        = "dev"
  retention_days     = 30
  bucket_name_suffix = "dev-data-001"
}
```

## Outputs

- `bucket_url` — gs:// URL of the bucket
- `bucket_self_link` — self-link for IAM bindings
- `kms_key_id` — CMEK resource ID
- `compliance_attestation` — machine-readable map of all control values

## AWS variants

| File | Control | Cloud | What it catches |
|------|---------|-------|----------------|
| `sc28_encryption_aws.rego` | SC-28 | AWS | S3 buckets missing server-side encryption config |
| `ac3_no_public_aws.rego` | AC-3 | AWS | S3 buckets missing or incomplete public access block |
| `cm6_required_tags_aws.rego` | CM-6 | AWS | Resources missing required tags (checks tags_all) |