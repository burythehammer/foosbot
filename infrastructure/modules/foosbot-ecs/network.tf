### Network

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}

resource "aws_vpc" "foosbot-vpc" {
  cidr_block = "172.17.0.0/16"
  tags {
    Name = "foosbot vpc"
  }
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  cidr_block = "${aws_vpc.foosbot-vpc.cidr_block}"
  vpc_id = "${aws_vpc.foosbot-vpc.id}"
  map_public_ip_on_launch = true
}

# IGW for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.foosbot-vpc.id}"
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.foosbot-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
}