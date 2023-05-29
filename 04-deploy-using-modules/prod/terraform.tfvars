access_key      = "%AWS_ACCESS_KEY%"
secret_key      = "%AWS_SECRET_KEY%"
instance_type   = "t2.micro"
security_grp    = "devops-nsg-prod"
aws_bucket_name = "devops-dpt-prod-bucket"
aws_common_tag = {
  Name = "devops-dpt-prod"
} 