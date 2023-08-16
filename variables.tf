variable "region" {
  type        = string
  description = ""
  default     = "us-east-1"
}

variable "ubuntu-amis" {
  description = "Ubuntu Images avaiables."
  default = {
    us-east-1 = "ami-0261755bbcb8c4a84"
    us-east-2 = "ami-0430580de6244e02e"
    us-west-1 = "ami-04d1dcfb793f6fa37"
    us-west-2 = "ami-0c65adc9a5c1b5d7c"
  }
}

variable "s3-bucket" {
  default = "s3://buck-devops/repository/mongodb/"
}