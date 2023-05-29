#Provision elastic ip resource
resource "aws_eip" "lb" {
  domain = "vpc" #vpc      = true
}