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