locals {
  aws_profile       = "devops"
  environment       = "dev"
  project           = "rc-mongodb"
  cidr_block        = "10.0.0.0/16"
  subnet_pvt_config = [
    {
      cidr_block     = "10.0.1.0/24"
      available_zone = "${var.region}a"
    },
    {
      cidr_block     = "10.0.2.0/24"
      available_zone = "${var.region}b"
    }
  ]

  subnet_pub_config = [
    {
      cidr_block     = "10.0.8.0/24"
      available_zone = "${var.region}a"
    },
    {
      cidr_block     = "10.0.9.0/24"
      available_zone = "${var.region}b"
    }
  ]
} 