provider "aws" {
  region  = var.region
  profile = local.aws_profile
}

module "vpc" {
  source            = "git::https://github.com/rogerio-calixto/aws-network-template.git?ref=master"
  aws_profile       = local.aws_profile
  aws_region        = var.region
  project           = local.project
  environment       = local.environment
  cidr_block        = local.cidr_block
  subnet_pvt_config = local.subnet_pvt_config
  subnet_pub_config = local.subnet_pub_config
}

data "template_file" "user_data" {
  template = file("scripts/userdata.sh")
  vars = {
    s3-bucket = var.s3-bucket
  }
}

resource "aws_iam_policy" "s3-rw-policy" {
  name        = "s3-rw-policy"
  path        = "/"
  description = "R/W S3 permitions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*",
          "s3:Put*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_rw_s3_role" {
  name = "${var.project}-EC2-To-S3-Role"
  managed_policy_arns = [
    "${aws_iam_policy.s3-rw-policy.arn}"
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "${var.project}-ec2_profile"
  role = aws_iam_role.ec2_rw_s3_role.name
}

module "instance" {
  source              = "git::https://github.com/rogerio-calixto/aws-instance-template.git?ref=master"
  aws_profile         = local.aws_profile
  region              = var.region
  project             = local.project
  environment         = local.environment
  instance-profile-name = aws_iam_instance_profile.ec2-profile.name
  user-data           = data.template_file.user_data.rendered
  ami                 = lookup(var.ubuntu-amis, var.region)
  instance-type       = "t3.micro"
  keypair-name        = "devops-keypair"
  vpc-id              = module.vpc.aws_vpc_id
  subnet-id           = module.vpc.public-subnet_ids[0]
  sg-id               = aws_security_group.sg-host.id
  associate-public-ip = true
  instance-name       = "${local.project}-server"
}

resource "aws_security_group" "sg-host" {
  name        = "${local.project}-sg-host"
  description = "Habilita acesso ao bastion host"
  vpc_id      = module.vpc.aws_vpc_id

  ingress {
    description     = "libera SSH para instance ip particular"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["179.125.170.200/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.project}-sg-calixto"
    Project     = local.project
    Environment = local.environment
  }

  depends_on = [ module.vpc ]
}