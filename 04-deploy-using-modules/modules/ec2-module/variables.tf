variable "instance_type" {
  type        = string
  description = "aws instance type"
  default     = "t2.nano"
}

variable "key_name" {
  type        = string
  description = "aws instance key name"
  default     = "aws-ec2"
}

variable "aws_common_tag" {
  type        = map(string)
  description = "aws tag"
  default = {
    Name = "devops-dpt"
  }
}

variable "security_grp" {
  type        = string
  description = "Security Group"
  default = "devops-nsg"
}