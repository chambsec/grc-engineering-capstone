output "wif_pool_name" {
  value       = google_iam_workload_identity_pool.github.name
  description = "WIF pool resource name."
}

output "wif_provider_name" {
  value       = google_iam_workload_identity_pool_provider.github.name
  description = "WIF provider resource name — use in GitHub Actions workflows."
}

output "service_account_email" {
  value       = google_service_account.gha.email
  description = "Service account email for GitHub Actions to impersonate."
}

output "compliance_attestation" {
  description = "Machine-readable attestation of controls deployed."
  value = {
    org_policy_uniform_bucket_access = "ENFORCED"
    org_policy_disable_sa_keys       = "ENFORCED"
    org_policy_require_oslogin       = "ENFORCED"
    wif_pool_created                 = true
    wif_attribute_condition          = "assertion.repository == \"${var.github_repo}\""
    data_access_logs_storage         = "DATA_READ + DATA_WRITE + ADMIN_READ"
    data_access_logs_kms             = "DATA_READ + DATA_WRITE + ADMIN_READ"
    data_access_logs_iam             = "ADMIN_READ + DATA_READ + DATA_WRITE"
  }
}