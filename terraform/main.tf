provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "edge_runtime" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.edge.id]
  subnet_id              = aws_subnet.private_a.id

  user_data = file("install-docker-k3s.sh")

  tags = {
    Name = "${local.prefix}-node"
  }
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
}

data "aws_region" "current" {}
