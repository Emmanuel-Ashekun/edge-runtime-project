provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "edge_runtime" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "EdgeRuntime"
  }
}
