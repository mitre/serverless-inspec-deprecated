output "ids" {
  description = "List of IDs of instances"
  value       = "${module.serverless-inspec.id}"
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances"
  value       = "${module.serverless-inspec.public_dns}"
}

output "vpc_security_group_ids" {
  description = "List of VPC security group ids assigned to the instances"
  value       = "${module.serverless-inspec.vpc_security_group_ids}"
}

output "tags" {
  description = "List of tags"
  value       = "${module.serverless-inspec.tags}"
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = "${module.serverless-inspec.id[0]}"
}

output "instance_public_dns" {
  description = "Public DNS name assigned to the EC2 instance"
  value       = "${module.serverless-inspec.public_dns[0]}"
}
