provider "aws" {
  region = var.region
}

## EC2 Instance
resource "aws_instance" "KTWSTP_webserver" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name = var.key_pair
  subnet_id = aws_subnet.KTWSTP_subnet.id
  vpc_security_group_ids  = [aws_security_group.KTWSTP_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = join("_", [var.base_prefix, "server_instance"])
    Project = var.base_prefix
  }
}


## AWS Virtual Private Cloud

resource "aws_vpc" "KTWSTP_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = join("_", [var.base_prefix, "vpc"])
    Project = var.base_prefix
  }
}


resource "aws_internet_gateway" "KTWSTP_ig" {
  vpc_id = aws_vpc.KTWSTP_vpc.id

  tags = {
    Name = join("_", [var.base_prefix, "ig"])
    Project = var.base_prefix
  }
}


resource "aws_subnet" "KTWSTP_subnet" {
  vpc_id     = aws_vpc.KTWSTP_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = join("_", [var.base_prefix, "subnet"])
    Project = var.base_prefix
  }
}

resource "aws_route_table" "KTWSTP_route_table" {
  vpc_id = aws_vpc.KTWSTP_vpc.id

  tags = {
    Name = join("_", [var.base_prefix, "route_table"])
    Project = var.base_prefix
  }
}

resource "aws_route" "KTWSTP_route" {
  route_table_id         = aws_route_table.KTWSTP_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.KTWSTP_ig.id
}


resource "aws_route_table_association" "KTWSTP_rt_association" {
  subnet_id      = aws_subnet.KTWSTP_subnet.id
  route_table_id = aws_route_table.KTWSTP_route_table.id
}



### Security Group (AWS Firewall)
resource "aws_security_group" "KTWSTP_sg" {
  name = join("_", [var.base_prefix, "sg"])
  description = "For the KTWSTP Instance"
  vpc_id      = aws_vpc.KTWSTP_vpc.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_ipv4_cidr_1
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_1
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_ipv4_cidr_1
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_1
  }


  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_ipv4_cidr_2
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("_", [var.base_prefix, "sg"])
    Project = var.base_prefix
  }
}