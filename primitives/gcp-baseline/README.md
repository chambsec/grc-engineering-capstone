# gcp-baseline

Deploys the GCP-native security services baseline for the CGE-P capstone.

## Controls enforced

| Feature | NIST 800-53 | What it does |
|---------|-------------|--------------|
| Org Policy: uniformBucketLevelAccess | CM-6 | Rejects GCS bucket creation without uniform access at the API |
| Org Policy: disableServiceAccountKeyCreation | AC-2 | Prevents long-lived service account JSON keys |
| Org Policy: requireOsLogin | AC-3 | Enforces OS Login on all compute instances |
| Workload Identity Federation | AC-2 | Replaces SA keys with short-lived OIDC tokens for GitHub Actions |
| Data Access audit logs (Storage, KMS, IAM) | AU-2, AU-12 | Enables per-service data access logging (off by default) |

## Key lesson: Data Access logs are off by default

GCP disables Data Access logs by default to avoid surprise billing.
This is the #1 GCP audit finding across most organizations.
This baseline enables them explicitly for Storage, KMS, and IAM.

## Key lesson: Org Policy vs Rego policies

Rego policies (Lab 3.3) are detective — they catch violations at plan time.
Org Policy is preventative — it rejects non-compliant API calls before
the resource exists. Both layers are needed for defense in depth.

## WIF attribute_condition

The `attribute_condition` in wif.tf restricts WIF to this specific repo only.
Without it, any GitHub repo on the public internet could impersonate the
service account. Never deploy a WIF provider without an attribute_condition.

## Evidence

`evidence/lab-5-4/iam-policy.json` — output of `gcloud projects get-iam-policy`
capturing the Data Access log configuration as machine-readable evidence.