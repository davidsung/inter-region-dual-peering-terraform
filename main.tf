module "earth" {
  source = "./modules/planet"

  providers = {
    aws = aws.earth
  }

  name                    = "earth"
  vpc_cidr                = var.earth_vpc_cidr
  instance_type           = var.instance_type
  network_interface_count = var.network_interface_count
  key_name                = var.key_name
  icmp_whitelist_cidrs    = [var.mars_vpc_cidr, var.venus_vpc_cidr]
  rdp_whitelist_cidrs     = [var.rdp_whitelist_cidr]
  nginx_whitelist_cidrs   = [var.mars_vpc_cidr, var.venus_vpc_cidr]

  tags = {
    Environment = var.environment
  }
}

module "earth_transit_gateway" {
  source = "./modules/transit-gateway"

  providers = {
    aws = aws.earth
  }

  name       = "earth"
  vpc_id     = module.earth.vpc_id
  subnet_ids = module.earth.vpc_public_subnets
  asn        = var.earth_asn

  tags = {
    Environment = var.environment
  }
}

module "mars" {
  source = "./modules/planet"

  providers = {
    aws = aws.mars
  }

  name                    = "mars"
  vpc_cidr                = var.mars_vpc_cidr
  instance_type           = var.instance_type
  network_interface_count = var.network_interface_count
  key_name                = var.key_name
  icmp_whitelist_cidrs    = [var.earth_vpc_cidr, var.venus_vpc_cidr]
  rdp_whitelist_cidrs     = [var.rdp_whitelist_cidr]
  nginx_whitelist_cidrs   = [var.mars_vpc_cidr, var.venus_vpc_cidr]

  tags = {
    Environment = var.environment
  }
}

module "mars_transit_gateway" {
  source = "./modules/transit-gateway"

  providers = {
    aws = aws.mars
  }

  name       = "mars"
  vpc_id     = module.mars.vpc_id
  subnet_ids = module.mars.vpc_public_subnets
  asn        = var.mars_asn

  tags = {
    Environment = var.environment
  }
}

module "venus" {
  source = "./modules/planet"

  providers = {
    aws = aws.venus
  }

  name                    = "venus"
  vpc_cidr                = var.venus_vpc_cidr
  instance_type           = var.instance_type
  network_interface_count = var.network_interface_count
  key_name                = var.key_name
  icmp_whitelist_cidrs    = [var.earth_vpc_cidr, var.mars_vpc_cidr]
  rdp_whitelist_cidrs     = [var.rdp_whitelist_cidr]
  nginx_whitelist_cidrs   = [var.mars_vpc_cidr, var.venus_vpc_cidr]

  tags = {
    Environment = var.environment
  }
}

module "venus_transit_gateway" {
  source = "./modules/transit-gateway"

  providers = {
    aws = aws.venus
  }

  name       = "venus"
  vpc_id     = module.venus.vpc_id
  subnet_ids = module.venus.vpc_public_subnets
  asn        = var.venus_asn

  tags = {
    Environment = var.environment
  }
}

module "earth_mars_peering" {
  source = "./modules/transit-gateway-peering"

  providers = {
    aws.local = aws.earth
    aws.peer  = aws.mars
  }

  peer_name   = "mars"
  peer_region = var.mars_region
  peer_destination_cidr_blocks = [
    cidrsubnet(module.mars.vpc_cidr, 4, 3),
    cidrsubnet(module.mars.vpc_cidr, 4, 4),
    cidrsubnet(module.mars.vpc_cidr, 4, 5),
  ]
  peer_transit_gateway_id                     = module.mars_transit_gateway.transit_gateway_id
  peer_tgw_vpc_attachment_id                  = module.mars_transit_gateway.transit_gateway_vpc_attachment_id
  peer_route_table_ids                        = module.mars.vpc_private_route_table_ids
  peer_transit_gateway_default_route_table_id = module.mars_transit_gateway.transit_gateway_association_default_route_table_id

  local_name = "earth"
  local_destination_cidr_blocks = [
    cidrsubnet(module.earth.vpc_cidr, 4, 3),
    cidrsubnet(module.earth.vpc_cidr, 4, 4),
    cidrsubnet(module.earth.vpc_cidr, 4, 5),
  ]
  transit_gateway_id                           = module.earth_transit_gateway.transit_gateway_id
  local_tgw_vpc_attachment_id                  = module.earth_transit_gateway.transit_gateway_vpc_attachment_id
  local_route_table_ids                        = module.earth.vpc_private_route_table_ids
  local_transit_gateway_default_route_table_id = module.earth_transit_gateway.transit_gateway_association_default_route_table_id
}

module "mars_venus_peering" {
  source = "./modules/transit-gateway-peering"

  providers = {
    aws.local = aws.mars
    aws.peer  = aws.venus
  }

  peer_name   = "venus"
  peer_region = var.venus_region
  peer_destination_cidr_blocks = [
    cidrsubnet(module.venus.vpc_cidr, 4, 3),
    cidrsubnet(module.venus.vpc_cidr, 4, 4),
    cidrsubnet(module.venus.vpc_cidr, 4, 5),
  ]
  peer_transit_gateway_id                     = module.venus_transit_gateway.transit_gateway_id
  peer_tgw_vpc_attachment_id                  = module.venus_transit_gateway.transit_gateway_vpc_attachment_id
  peer_route_table_ids                        = module.venus.vpc_private_route_table_ids
  peer_transit_gateway_default_route_table_id = module.venus_transit_gateway.transit_gateway_association_default_route_table_id

  local_name = "mars"
  local_destination_cidr_blocks = [
    cidrsubnet(module.mars.vpc_cidr, 4, 3),
    cidrsubnet(module.mars.vpc_cidr, 4, 4),
    cidrsubnet(module.mars.vpc_cidr, 4, 5),
  ]
  transit_gateway_id                           = module.mars_transit_gateway.transit_gateway_id
  local_tgw_vpc_attachment_id                  = module.mars_transit_gateway.transit_gateway_vpc_attachment_id
  local_route_table_ids                        = module.mars.vpc_private_route_table_ids
  local_transit_gateway_default_route_table_id = module.mars_transit_gateway.transit_gateway_association_default_route_table_id
}

module "venus_earth_peering" {
  source = "./modules/transit-gateway-peering"

  providers = {
    aws.local = aws.venus
    aws.peer  = aws.earth
  }

  peer_name   = "earth"
  peer_region = var.earth_region
  peer_destination_cidr_blocks = [
    cidrsubnet(module.earth.vpc_cidr, 4, 3),
    cidrsubnet(module.earth.vpc_cidr, 4, 4),
    cidrsubnet(module.earth.vpc_cidr, 4, 5),
  ]
  peer_transit_gateway_id                     = module.earth_transit_gateway.transit_gateway_id
  peer_tgw_vpc_attachment_id                  = module.earth_transit_gateway.transit_gateway_vpc_attachment_id
  peer_route_table_ids                        = module.earth.vpc_private_route_table_ids
  peer_transit_gateway_default_route_table_id = module.earth_transit_gateway.transit_gateway_association_default_route_table_id

  local_name = "venus"
  local_destination_cidr_blocks = [
    cidrsubnet(module.venus.vpc_cidr, 4, 3),
    cidrsubnet(module.venus.vpc_cidr, 4, 4),
    cidrsubnet(module.venus.vpc_cidr, 4, 5),
  ]
  transit_gateway_id                           = module.venus_transit_gateway.transit_gateway_id
  local_tgw_vpc_attachment_id                  = module.venus_transit_gateway.transit_gateway_vpc_attachment_id
  local_route_table_ids                        = module.venus.vpc_private_route_table_ids
  local_transit_gateway_default_route_table_id = module.venus_transit_gateway.transit_gateway_association_default_route_table_id
}

module "earth_mars_vpc_peering" {
  source = "./modules/vpc-peering"

  providers = {
    aws.local = aws.earth
    aws.peer  = aws.mars
  }

  local_vpc_id         = module.earth.vpc_id
  local_vpc_cidr       = module.earth.vpc_cidr
  local_route_table_id = module.earth.vpc_private_route_table_ids.0
  local_private_cidr_blocks = [
    cidrsubnet(module.earth.vpc_cidr, 4, 0),
    cidrsubnet(module.earth.vpc_cidr, 4, 1),
    cidrsubnet(module.earth.vpc_cidr, 4, 2)
  ]

  peer_region         = var.mars_region
  peer_vpc_id         = module.mars.vpc_id
  peer_vpc_cidr       = module.mars.vpc_cidr
  peer_route_table_id = module.mars.vpc_private_route_table_ids.0
  peer_private_cidr_blocks = [
    cidrsubnet(module.mars.vpc_cidr, 4, 0),
    cidrsubnet(module.mars.vpc_cidr, 4, 1),
    cidrsubnet(module.mars.vpc_cidr, 4, 2)
  ]
}

module "mars_venus_vpc_peering" {
  source = "./modules/vpc-peering"

  providers = {
    aws.local = aws.mars
    aws.peer  = aws.venus
  }

  local_vpc_id         = module.mars.vpc_id
  local_vpc_cidr       = module.mars.vpc_cidr
  local_route_table_id = module.mars.vpc_private_route_table_ids.0
  local_private_cidr_blocks = [
    cidrsubnet(module.mars.vpc_cidr, 4, 0),
    cidrsubnet(module.mars.vpc_cidr, 4, 1),
    cidrsubnet(module.mars.vpc_cidr, 4, 2)
  ]

  peer_region         = var.venus_region
  peer_vpc_id         = module.venus.vpc_id
  peer_vpc_cidr       = module.venus.vpc_cidr
  peer_route_table_id = module.venus.vpc_private_route_table_ids.0
  peer_private_cidr_blocks = [
    cidrsubnet(module.venus.vpc_cidr, 4, 0),
    cidrsubnet(module.venus.vpc_cidr, 4, 1),
    cidrsubnet(module.venus.vpc_cidr, 4, 2),
  ]
}

module "venus_earth_vpc_peering" {
  source = "./modules/vpc-peering"

  providers = {
    aws.local = aws.venus
    aws.peer  = aws.earth
  }

  local_vpc_id         = module.venus.vpc_id
  local_vpc_cidr       = module.venus.vpc_cidr
  local_route_table_id = module.venus.vpc_private_route_table_ids.0
  local_private_cidr_blocks = [
    cidrsubnet(module.venus.vpc_cidr, 4, 0),
    cidrsubnet(module.venus.vpc_cidr, 4, 1),
    cidrsubnet(module.venus.vpc_cidr, 4, 2),
  ]

  peer_region         = var.earth_region
  peer_vpc_id         = module.earth.vpc_id
  peer_vpc_cidr       = module.earth.vpc_cidr
  peer_route_table_id = module.earth.vpc_private_route_table_ids.0
  peer_private_cidr_blocks = [
    cidrsubnet(module.earth.vpc_cidr, 4, 0),
    cidrsubnet(module.earth.vpc_cidr, 4, 1),
    cidrsubnet(module.earth.vpc_cidr, 4, 2),
  ]
}
