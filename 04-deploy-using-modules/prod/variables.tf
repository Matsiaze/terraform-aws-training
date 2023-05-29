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
}

variable "aws_bucket_name" {
  type        = string
  description = "aws bucket name"
}

variable "aws_common_tag" {
  type        = map(string)
  description = "aws tag"
}

variable "security_grp" {
  type        = string
  description = "Security Group"
}
