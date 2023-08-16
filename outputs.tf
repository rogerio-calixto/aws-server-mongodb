output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.aws_vpc_id
}

output "vpc_avaiable_zones" {
  description = "Avaiable zones"
  value       = module.vpc.avaiable_zones
}

output "vpc_privateSubNetIds" {
  description = "List ID from private subnets created"
  value       = module.vpc.private-subnet_ids
}

output "vpc_publicSubNetIds" {
  description = "List ID from public subnets created"
  value       = module.vpc.public-subnet_ids
}

output "instance_private_ip" {
  description = "private ip"
  value       = module.instance.ec2_private_ip
}

output "instance_public_ip" {
  description = "public ip"
  value       = module.instance.ec2_public_ip
}

output "sg-id" {
  description = "sg id"
  value       = aws_security_group.sg-host.id
}