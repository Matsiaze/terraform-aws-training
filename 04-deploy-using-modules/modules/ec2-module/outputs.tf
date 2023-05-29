output "ec2_id" {
  description = "ec2-instance ID"  
  value = aws_instance.aws-ec2.id
}