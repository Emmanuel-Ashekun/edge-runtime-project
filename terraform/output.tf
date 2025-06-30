output "aws_instance_id" {
  description = "ec2 public-ip"
  value = aws_instance.edge_runtime.public_ip
}
