#Step: Configure aws provider
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
#Step: Provision an instance 
resource "aws_instance" "aws-ec2" {
  ami             = data.aws_ami.app_ami.id #var.aws_ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  tags            = var.aws_common_tag
  security_groups = ["${aws_security_group.allow_ssh_http_https.name}"]

  #Post-deploy-op1: install nginx on remote instance
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
#Post-deploy operation
#use null_resource to execute local commands
resource "null_resource" "local_exec" {
  provisioner "local-exec" {
    command = "echo PUBLIC EIP: ${aws_eip.lb.public_ip}; ID : ${aws_instance.aws-ec2.id}; AD: ${aws_instance.aws-ec2.availability_zone}; >> out.txt"
  }
  # Trigger the local-exec provisioner after the EC2 instance is created
  depends_on = [aws_instance.aws-ec2]
}

#Step : Provision security group resource
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

#Step: Provision elastic ip resource associated to instance
resource "aws_eip" "lb" {
  instance = aws_instance.aws-ec2.id
  vpc      = true
}

# Step: Outputs
output "ec2_public_ip" {
  value = aws_instance.aws-ec2.public_ip
}
output "elastic_ip" {
  value = aws_eip.lb.public_ip
}
output "ec2_id" {
  value = aws_instance.aws-ec2.id
}
output "az" {
  value = aws_instance.aws-ec2.availability_zone
}