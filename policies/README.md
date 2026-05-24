# Compliance Policy Library

Rego policies for the CGE-P certification capstone. Each policy maps to a
NIST 800-53 control and operates on `terraform show -json` plan output.
Nothing is deployed — policies run at plan time.

## Policies

| File | Control | Severity | What it catches |
|------|---------|----------|----------------|
| `sc28_encryption.rego` | SC-28 | High | GCS buckets missing CMEK encryption block |
| `ac3_no_public.rego` | AC-3 | Critical | Public GCS buckets; firewalls exposing port 22 or 3389 to 0.0.0.0/0 |
| `cm6_required_tags.rego` | CM-6 | Medium | Resources missing any of the four required labels |

## Required labels (CM-6)

Every taggable resource must carry all four:

- `project`
- `environment`
- `managed_by`
- `compliance_scope`

## Running the tests

```bash
opa test -v policies/
```

Expected: `PASS: 8/8`

## Evaluating against a real plan

```bash
opa eval -d policies -i <path-to-plan.json> data.compliance.sc28.deny --format=pretty
opa eval -d policies -i <path-to-plan.json> data.compliance.ac3.deny  --format=pretty
opa eval -d policies -i <path-to-plan.json> data.compliance.cm6.deny  --format=pretty
```

## Remediation

Each deny message includes the resource address and a specific remediation
instruction so developers can fix violations without filing a GRC ticket.