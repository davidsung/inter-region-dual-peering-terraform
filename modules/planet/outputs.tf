output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "vpc_private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "linux_instance_id" {
  value = module.compute_linux.instance_id
}

output "linux_private_ips" {
  value = module.compute_linux.private_ips
}
