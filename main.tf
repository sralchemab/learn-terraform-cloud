provider "aws" {
  region = var.region
}

# data "aws_vpc" "main" {
#   filter {
#     name   = "tag:Name"
#     values = ["aws-controltower-VPC"]
#   }
# }

data "aws_subnet" "app_subnet_1a" {
  filter {
    name   = "tag:Name"
    values = ["aws-controltower-PrivateSubnet1A"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.app_subnet_1a.id

  tags = {
    Name = var.instance_name
  }
}
