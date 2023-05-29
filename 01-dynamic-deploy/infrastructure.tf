#Step1: Configure aws provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key 
  secret_key = var.secret_key
}

#Set the most recent ami
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
#Step2: Provision an instance 
resource "aws_instance" "aws-ec2" {
  ami           = data.aws_ami.app_ami.id #var.aws_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  #Tag your resource
  tags = var.aws_common_tag

  #Add to security group
  security_groups = ["${aws_security_group.allow_http_https.name}"]

  #Persist volume deletion on instance termination
  root_block_device {
    delete_on_termination = true
  }
}

#Step3: Provision security group resource
resource "aws_security_group" "allow_http_https" {
  name        = "devops-nsg"
  description = "Allow HTTP-s inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_common_tag
}

#Step4: Provision elastic ip resource associated to instance
resource "aws_eip" "lb" {
  instance = aws_instance.aws-ec2.id
  vpc      = true
}
