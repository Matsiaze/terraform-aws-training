#Set ami
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#Call security group module to get the name
module "nsg-module" {
  source = "../nsg-module"
  security_grp = var.security_grp
  aws_common_tag = var.aws_common_tag
}

#Provision ec2 instance 
resource "aws_instance" "aws-ec2" {
  ami             = data.aws_ami.app_ami.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  tags            = var.aws_common_tag
  security_groups = ["${module.nsg-module.nsg_name}"]

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
      private_key = file("../secrets/${var.key_name}.pem") #Set path to your private key
      host        = self.public_ip
    }
  }
  root_block_device {
    delete_on_termination = true
  }
}