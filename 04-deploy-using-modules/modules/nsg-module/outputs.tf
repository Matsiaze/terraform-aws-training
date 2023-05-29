output "nsg_name" {
  description = "Security group name"  
  value = aws_security_group.allow_ssh_http_https.name
}