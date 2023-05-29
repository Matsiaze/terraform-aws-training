provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

#Store terraform state file
# terraform {
#   backend "s3" {
#     bucket     = "devops-dpt-dev-bucket"
#     key        = ".terraform/terraform.tfstate"
#     region     = "us-east-1"
#     access_key = var.access_key
#     secret_key = var.secret_key
#   }
# }

module "ec2-module" {
  source         = "../modules/ec2-module"
  instance_type  = var.instance_type
  aws_common_tag = var.aws_common_tag
  security_grp   = var.security_grp
}

module "eip-module" {
  source = "../modules/eip-module"
}

module "aws-s3" {
  source          = "../modules/s3-module"
  aws_bucket_name = var.aws_bucket_name
  aws_common_tag  = var.aws_common_tag
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2-module.ec2_id
  allocation_id = module.eip-module.eip_id
}

#Outputs
output "elastic_ip" {
  value = module.eip-module.eip
}
output "aws_s3_regional_domain" {
  value = module.aws-s3.aws_s3_regional_domain
}