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
  vpc_security_group_ids = [aws_security_group.web-01-sg.id]
  for_each = toset(var.webservers)
  user_data = file("user-data.sh")

  tags = {
    Name = each.value
  }
}

resource "aws_security_group" "web-01-sg" {
  name        = "web-01-sg"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}