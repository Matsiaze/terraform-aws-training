output "eip" {
  description = "Elastic IP address"  
  value = aws_eip.lb.public_ip
}
output "eip_id" {
  description = "ID of Elastic IP"  
  value = aws_eip.lb.id
}