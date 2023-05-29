#Provision bucket
resource "aws_s3_bucket" "devops-bucket" {
  bucket = var.aws_bucket_name
  tags   = var.aws_common_tag
}