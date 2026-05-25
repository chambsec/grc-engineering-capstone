variable "gcp_project" {
  type        = string
  description = "GCP project ID."
  default     = "cgep-sandbox"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo allowed to use WIF. Format: owner/repo"
  default     = "chambsec/cgep-capstone"
}