#########
## VPC ##

resource "aws_vpc" "VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "${var.resource_prefix}-VPC"
    },
    var.default_tags,
  )
}

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.VPC.id
#   service_name = "com.amazonaws.${var.aws_region}.s3"
# }


######################
## Internet Gateway ##

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.VPC.id
  tags = merge(
    {
      Name = "${var.resource_prefix}-IG"
    },
    var.default_tags,
  )
}

##################
## Route tables ##

resource "aws_route_table" "public_table" {
  vpc_id = aws_vpc.VPC.id
  tags = merge(
    {
      Name = "${var.resource_prefix}-Public Route Table"
    },
    var.default_tags,
  )
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IG.id
}

resource "aws_route_table" "private_table" {
  vpc_id = aws_vpc.VPC.id
  tags = merge(
    {
      Name = "${var.resource_prefix}-Private Route Table"
    },
    var.default_tags,
  )
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

#############
## Subnets ##

resource "aws_subnet" "public_subnet" {
  count                = length(var.vpc_public_subnets)
  vpc_id               = aws_vpc.VPC.id
  cidr_block           = element(concat(var.vpc_public_subnets, [""]), count.index)
  availability_zone_id = element(var.vpc_azs_id, count.index)
  tags = merge(
    {
      Name = "${var.resource_prefix}-Public Subnet ${count.index}"
    },
    var.default_tags,
  )
}

resource "aws_subnet" "private_subnet" {
  count                = length(var.vpc_private_subnets)
  vpc_id               = aws_vpc.VPC.id
  cidr_block           = element(concat(var.vpc_private_subnets, [""]), count.index)
  availability_zone_id = element(var.vpc_azs_id, count.index)
  tags = merge(
    {
      Name = "${var.resource_prefix}-Private Subnet ${count.index}"
    },
    var.default_tags,
  )
}

#############################
## Route Table Association ##

resource "aws_route_table_association" "public" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_table.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.vpc_private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_table.id
}

# resource "aws_vpc_endpoint_route_table_association" "s3" {
#   route_table_id  = aws_route_table.private_table.id
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
# }


##################
##  NAT Gateway ##

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = merge(
    {
      Name = "${var.resource_prefix}-NATGW-1"
    },
    var.default_tags,
  )
  depends_on = [aws_internet_gateway.IG]
}


resource "aws_eip" "nat" {
  vpc = true
}


#########################
## Default Network ACL ##

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.VPC.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

############################
## Default Security Group ##

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.VPC.id
}

#################
## EC2 Key Par ##

resource "aws_key_pair" "key" {
  key_name   = "Marcos_test"
  public_key = var.pub_key
}
