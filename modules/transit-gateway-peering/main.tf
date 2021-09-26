// Local to Peer Inter Region Peering
resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  provider                = aws.local
  peer_region             = var.peer_region
  peer_transit_gateway_id = var.peer_transit_gateway_id
  transit_gateway_id      = var.transit_gateway_id
  tags = merge(
    {
      Name : "${var.local_name}-${var.peer_name}-tgw-peering"
    },
    var.tags
  )
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering_acceptor" {
  provider                      = aws.peer
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
  tags = merge(
    {
      Name : "${var.peer_name}-${var.local_name}-tgw-peering"
    },
    var.tags
  )
}

// Update Peer routes in Local route table
resource "aws_route" "peer_route_in_local" {
  count                  = length(var.peer_destination_cidr_blocks)
  provider               = aws.local
  route_table_id         = var.local_route_table_ids.0
  destination_cidr_block = var.peer_destination_cidr_blocks[count.index]
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_ec2_transit_gateway_route" "peer_tgw_route_in_local" {
  count                          = length(var.peer_destination_cidr_blocks)
  provider                       = aws.local
  transit_gateway_route_table_id = var.local_transit_gateway_default_route_table_id
  destination_cidr_block         = var.peer_destination_cidr_blocks[count.index]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
  depends_on                     = [aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_acceptor]
}

resource "aws_ec2_transit_gateway_route_table_association" "local_tgw_route_table_association" {
  provider                       = aws.local
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_acceptor.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.local_transit_gateway_default_route_table_id
}

// Update Local routes in Peer route table
resource "aws_route" "local_route_in_peer" {
  count                  = length(var.local_destination_cidr_blocks)
  provider               = aws.peer
  route_table_id         = var.peer_route_table_ids.0
  destination_cidr_block = var.local_destination_cidr_blocks[count.index]
  transit_gateway_id     = var.peer_transit_gateway_id
  depends_on             = [aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_acceptor]
}

resource "aws_ec2_transit_gateway_route" "local_tgw_route_in_peer" {
  count                          = length(var.local_destination_cidr_blocks)
  provider                       = aws.peer
  transit_gateway_route_table_id = var.peer_transit_gateway_default_route_table_id
  destination_cidr_block         = var.local_destination_cidr_blocks[count.index]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_acceptor.id
  depends_on                     = [aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_acceptor]
}

resource "aws_ec2_transit_gateway_route_table_association" "peer_tgw_route_table_association" {
  provider                       = aws.peer
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_acceptor.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.peer_transit_gateway_default_route_table_id
}
