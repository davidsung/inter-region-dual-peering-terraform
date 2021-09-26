output "earth_region" {
  value = var.earth_region
}

output "mars_region" {
  value = var.mars_region
}

output "venus_region" {
  value = var.venus_region
}

output "earth_vpc_id" {
  value = module.earth.vpc_id
}

output "mars_vpc_id" {
  value = module.mars.vpc_id
}

output "venus_vpc_id" {
  value = module.venus.vpc_id
}

output "earth_tgw_id" {
  value = module.earth_transit_gateway.transit_gateway_id
}

output "mars_tgw_id" {
  value = module.mars_transit_gateway.transit_gateway_id
}

output "venus_tgw_id" {
  value = module.venus_transit_gateway.transit_gateway_id
}

output "earth_linux_instance_id" {
  value = module.earth.linux_instance_id
}

output "earth_linux_private_ips" {
  value = module.earth.linux_private_ips
}

output "mars_linux_instance_id" {
  value = module.mars.linux_instance_id
}

output "mars_linux_private_ips" {
  value = module.mars.linux_private_ips
}

output "venus_linux_instance_id" {
  value = module.venus.linux_instance_id
}

output "venus_linux_private_ips" {
  value = module.venus.linux_private_ips
}
