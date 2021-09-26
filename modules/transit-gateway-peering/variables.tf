variable "local_name" {
  type    = string
  default = "local"
}

variable "peer_name" {
  type    = string
  default = "peer"
}

variable "peer_region" {
  type        = string
  description = "Peer Region"
}

variable "peer_transit_gateway_id" {
  type        = string
  description = "Peert Transit Gateway id"
}

variable "transit_gateway_id" {
  type        = string
  description = "Transit Gateway id"
}

variable "local_transit_gateway_default_route_table_id" {
  type = string
}

variable "peer_transit_gateway_default_route_table_id" {
  type = string
}

variable "local_tgw_vpc_attachment_id" {
  type = string
}

variable "peer_tgw_vpc_attachment_id" {
  type = string
}

variable "local_route_table_ids" {
  type = list(string)
}

variable "peer_route_table_ids" {
  type = list(string)
}

variable "local_destination_cidr_blocks" {
  type        = list(string)
  description = "Local Destination CIDR Block"
}

variable "peer_destination_cidr_blocks" {
  type        = list(string)
  description = "Peer Destination CIDR Blocks"
}

variable "tags" {
  type    = map(string)
  default = {}
}
