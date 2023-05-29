output "aws_s3_regional_domain" {
  value = aws_s3_bucket.devops-bucket.bucket_regional_domain_name
}
output "aws_s3_name" {
  value = aws_s3_bucket.devops-bucket.bucket
}