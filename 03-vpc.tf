## VPC Begin ##

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_subnets}"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "ee-vpc"
  }
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "ee-inet-gw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  count                   = "${length(var.public_cidr_subnets)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(var.public_cidr_subnets, count.index)}"
  map_public_ip_on_launch = "true"
  # availability_zone       = "${element(var.avalibility_zone, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "ee-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = "${length(var.private_cidr_subnets)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.private_cidr_subnets, count.index)}"
  availability_zone = "${element(var.avalibility_zone, count.index)}"

  tags = {
    Name = "ee-private-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo_igw.id}"
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_cidr_subnets)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_cidr_subnets)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"
}

## VPC END

## Security Group Begin

resource "aws_security_group" "public_sg" {
  name_prefix = "public-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    description = "All"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    Name = "private-security-group"
  }
}

resource "aws_security_group" "private_sg" {
  name_prefix = "private-sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-security-group"
  }
}

resource "aws_security_group_rule" "all_traffic_from_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${var.vpc_cidr_subnets}"]
  security_group_id = "${aws_security_group.private_sg.id}"
}

##Security Group End ##

