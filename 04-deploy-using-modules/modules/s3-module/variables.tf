variable "aws_common_tag" {
  type        = map(string)
  description = "aws tag"
  default = {
    Name = "devops-dpt"
  }
}

variable "aws_bucket_name" {
  type        = string
  description = "aws bucket name"
  default = "devops-dpt-bucket"
}