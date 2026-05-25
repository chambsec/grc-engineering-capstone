# METADATA
# title: AC-3 - Access Enforcement (AWS S3 public access block)
# description: "Every aws_s3_bucket must have an aws_s3_bucket_public_access_block referencing it, with all four flags true."
# custom:
#   control_id: AC-3
#   framework: nist-800-53
#   severity: critical
package compliance.ac3_aws

import rego.v1

deny contains msg if {
	bucket := bucket_addresses[_]
	not has_complete_pab(bucket)
	msg := sprintf(
		"[AC-3] %s: missing or incomplete aws_s3_bucket_public_access_block. All four flags must be true.",
		[bucket],
	)
}

bucket_addresses contains addr if {
	some r in input.configuration.root_module.resources
	r.type == "aws_s3_bucket"
	addr := sprintf("aws_s3_bucket.%s", [r.name])
}

has_complete_pab(bucket_addr) if {
	some r in input.configuration.root_module.resources
	r.type == "aws_s3_bucket_public_access_block"
	some ref in r.expressions.bucket.references
	pab_references_bucket(ref, bucket_addr)
	expr := r.expressions
	expr.block_public_acls.constant_value == true
	expr.block_public_policy.constant_value == true
	expr.ignore_public_acls.constant_value == true
	expr.restrict_public_buckets.constant_value == true
}

pab_references_bucket(ref, bucket_addr) if ref == bucket_addr
pab_references_bucket(ref, bucket_addr) if ref == sprintf("%s.id", [bucket_addr])