output "bucket_backend_name" {
  value = aws_s3_bucket.s3_bucket_backend.bucket
}

output "bucket_dns_name" {
  value = aws_s3_bucket.s3_bucket_frontend.bucket_regional_domain_name
}