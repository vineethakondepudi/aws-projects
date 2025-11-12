# output.tf

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.mysql_instance.public_ip
}

output "subnet_id" {
  description = "Subnet ID used for EC2"
  value       = var.subnet_id
}

output "security_group_ids" {
  description = "Security Group IDs used for EC2"
  value       = var.vpc_security_group_ids
}

output "region" {
  description = "AWS region in use"
  value       = var.region
}
