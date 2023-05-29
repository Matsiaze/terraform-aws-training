variable "access_key" {
  type        = string
  description = "access key"
}

variable "secret_key" {
  type        = string
  description = "secret key"
}

variable "instance_type" {
  type        = string
  description = "aws instance type"
  default     = "t2.nano"
}

variable "key_name" {
  type        = string
  description = "aws instance key name"
}

variable "aws_common_tag" {
  type        = map(string)
  description = "aws tag"
  default = {
    Name = "devops-dpt"
  }
}