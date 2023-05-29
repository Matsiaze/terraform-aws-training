#Connect to aws
provider "aws" {
  region     = "us-east-1"
  access_key = "***Put your access key here"
  secret_key = "**Put your secret key here**"
}

#Provision an instance 
resource "aws_instance" "myec2" {
  ami           = "ami-0aedf6b1cb669b4c7" #centos7
  instance_type = "t2.micro"
  key_name      = "devopskey-nnprod" #This is the name of the key pair you create in ec2 service

  #Add some tag
  tags = {
    Name = "devops-nnprod" #Tag your resource
  }

  #Make sure EBS Volume is deleted
  root_block_device {
    delete_on_termination = true
  }
}