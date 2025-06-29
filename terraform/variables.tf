variable "aws_region" {
    description = "region where infra will be deployed"
    default = "us-east-1"
  
}

variable "instance_type" {
    description = "size of the instance/type"
    default = "t2.micro"
  
}

variable "ami_id" {
    description = "ubuntu ami id"
    default = "ami-0dd9f0e7df0f0a138"
  
}
