provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id     = "subnet-12345678"
  security_groups = ["sg-12345678"]
  key_name      = "my_key"
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 20
  encrypted         = true
}

resource "aws_security_group" "example" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
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

resource "aws_elb" "example" {
  name               = "example-elb"
  availability_zones = ["us-west-2a"]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
}