# compliant-s3

This module deploys a compliant AWS S3 bucket enforcing five NIST 800-53 controls:
SC-28 (AES-256 encryption at rest), AC-3 (all public access blocked), CM-6 (required
compliance tags via provider default_tags and versioning enabled), AU-3 (server access
logging to a dedicated log bucket), and AU-6 (log bucket itself encrypted and public-access blocked).