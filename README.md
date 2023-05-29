## Use this discovery script to deploy an aws instance using terraform

*Enjoy and feel free to improve it for your own purpose*

  > **Pre-requisites**: 
     - Install terraform on your system. See Documentation here *https://developer.hashicorp.com/terraform/downloads*

     - Create your AWS account and use IAM service to add a user admin

     - Create an access key for user admin in IAM and update the ec2.tf file

     - Create a key pair in EC2 service and update the ec2.tf file

## 00-Run terraform from your workspace 
  > **Run terraform commands**:

     - [ terraform init ] To initialize the working directory that contains the script

     - [ terraform plan ] To create your execution plan and view what action terraform will perfom

     - [ terraform apply ] To execute actions planned
     
     - [ terraform destroy] To destroy all the created resources

## 01-Deploy your infrastructure dynamically
In the repository **dynamic-deploy**, we variabilize our provisionning using *variable.tf* and *terraform.tfvars*
   > **What do we deploy as infrastructure?**

     - An aws ec2 instance with, as data, one of most recent amazon image instance type we define

     - A security group for allowing http_https inbond traffic, attached to our instance

     - An elastic ip address, associated to our instance

## 02-Perform some post deploy operations
In the repository **dynamic-ops-post-deploy**, we use *provisioners* to perform some post deploy operations
   > **Provisioners**

     - *local-exec*: uses your local terraform runner to execute commands locally

     - *remote-exec* : performs action on your remote instance. Hence necessity to set up proper ingress/egress rules

     - Here we performed deployment of nginx on remote instance. Test by pasting your public ip in your nav

     - Use terraform outputs to retrieve needed infos in your console

## 03-Enhance best practices and remote-management
In the repository **remote-backend**, we provision an aws s3 bucket to store our terraform state file, making our actions trackable and versionable
   > **Documentation**

     - For more: https://developer.hashicorp.com/terraform/language/settings/backends/s3

## 04-Use Terraform modules for a better maintainability
In the repository **deploy-using-modules**, we use *modules* to isolate our infrastructure provisioning by resource
   > **Modules**

     - [ ec2-module ] To provision the aws-ec2 instance. Dependency with nsg-module. Output file collects the ec2-id to attach with eip

     - [ nsg-module ] To provision security group. Output file collects the sg name to inject to ec2 instance

     - [ eip-module ] To provision our elastic ip. Dependency with ec2-module

     - [ s3-module ] To provision our aws s3 bucket to store tfstate. This being done, you can uncomment the terraform backend part and run *terraform init migrate tfstate*

     - [ dev ] This repository calls the ec2 module to deploy a dev ec2 with the proper dev tag

     - [ prod ] This repository calls the ec2 module to deploy a prod ec2 with the proper prod tag

