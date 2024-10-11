data "aws_vpc" "default" {
  default = true
}

resource "tls_private_key" "web-key" {
  algorithm = var.private-key-data["algorithm"]
  rsa_bits  = var.private-key-data["rsa_bits"]
}

resource "aws_key_pair" "web-01-key" {
  key_name   = "web-01-key"
  public_key = tls_private_key.web-key.public_key_openssh
}

resource "local_sensitive_file" "web-01-private-key" {
  filename        = "web-01-key.pem"
  content         = tls_private_key.web-key.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "web-01" {
  ami                    = var.web-01-ami
  instance_type          = var.web-01-instance-type
  key_name               = aws_key_pair.web-01-key.key_name
  vpc_security_group_ids = module.web-01-sg.security_group_id
  for_each = toset(var.webservers)
  user_data = file("user-data.sh")

  tags = {
    Name = each.value
  }
}

module "web-01-sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-01-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = data.aws_vpc.default.id
  ingress_rules            = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]

  ingress_cidr_blocks = ["10.10.0.0/16"]
}

module "web-01-s3-bucket" {
  source = "./modules/generic-s3-bucket"
  generic-s3-bucket-name = var.web-01-bucket-name
}