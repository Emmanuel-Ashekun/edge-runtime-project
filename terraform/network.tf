resource "aws_vpc" "edge" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.edge.id
  map_public_ip_on_launch = true
    cidr_block        = "10.1.1.0/24"
  availability_zone       = "${data.aws_region.current.name}a"
  tags = {
    Name = "${local.prefix}-public-a"
  }

}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.edge.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "${data.aws_region.current.name}a"


  tags = {
    Name = "${local.prefix}-private-a"
  }


}


resource "aws_security_group" "edge" {
  description = "Access to endpoints"
  name        = "${local.prefix}-edge"
  vpc_id      = aws_vpc.edge.id


  ingress {
    cidr_blocks = [aws_vpc.edge.cidr_block]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
}



resource "aws_vpc_endpoint" "SSM" {
  vpc_id              = aws_vpc.edge.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [aws_subnet.private_a.id]

  security_group_ids = [
    aws_security_group.edge.id
  ]

  tags = {
    Name = "${local.prefix}-ssmmessages-endpoint"
  }
}
