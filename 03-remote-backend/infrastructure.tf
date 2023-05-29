#Configure aws provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
#Store terraform state file
terraform {
  backend "s3" {
    bucket     = "devops-dpt-bucket"
    key        = ".terraform/terraform.tfstate"
    region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  }
}
#Set ami
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
#Provision ec2 instance 
resource "aws_instance" "aws-ec2" {
  ami             = data.aws_ami.app_ami.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  tags            = var.aws_common_tag
  security_groups = ["${aws_security_group.allow_ssh_http_https.name}"]

  # deploy nginx on remote server
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
    connection {
      type        = "ssh" #Set ssh traffic on nsg
      user        = "ec2-user"
      private_key = file("./${var.key_name}.pem") #Set path to your private key
      host        = self.public_ip
    }
  }
  root_block_device {
    delete_on_termination = true
  }
}

#Provision network security group
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "devops-nsg"
  description = "Allow HTTP-s & ssh inbound traffic"

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

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "from vpc to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_common_tag
}

#Provision elastic ip resource associated to ec2-instance
resource "aws_eip" "lb" {
  instance = aws_instance.aws-ec2.id
  vpc      = true
}

#Provision bucket
resource "aws_s3_bucket" "devops-bucket" {
  bucket = "devops-dpt-bucket"
  tags   = var.aws_common_tag
}

#Outputs
output "aws_s3_regional_domain" {
  value = aws_s3_bucket.devops-bucket.bucket_regional_domain_name
}
output "elastic_ip" {
  value = aws_eip.lb.public_ip
}
output "ec2_id" {
  value = aws_instance.aws-ec2.id
}
output "zone" {
  value = aws_instance.aws-ec2.availability_zone
}