/*
  jump box
*/

/*
AMI
*/
data "aws_ami" "Ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_ami" "AmazonLinux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["137112412989"] # Amazon
}

data "aws_ami" "CentOS" {
  most_recent = true
  filter {
    name   = "name"
    values = ["CentOS 8*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["125523088429"] # CentOS
}

/*
SecurityGroup
*/
resource "aws_security_group" "jumpbox" {
  name        = "${var.resource_prefix}-jumpbox-SG"
  description = "Allow incoming connections."


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["24.84.233.107/32"]
    description = "Marcos Rocha Home"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.VPC.id
  tags = merge(
    {
      Name = "${var.resource_prefix}-jumpboxSG"
    },
    var.default_tags,
  )
}

/*
EC2 Isstance
*/

## Linux
resource "aws_instance" "linux_jumpbox" {
  ami           = data.aws_ami.AmazonLinux.id
  instance_type = "t3a.nano"
  credit_specification {
    cpu_credits = "standard"
  }
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.jumpbox.id]
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  root_block_device {
    delete_on_termination = "true"
    volume_size           = 8
    volume_type           = "standard"
  }
  tags = merge(
    {
      Name = "Linux_Jumpbox"
    },
    var.default_tags,
  )
  lifecycle {
    ignore_changes = [ami]
  }
}
resource "aws_eip" "linux_jumpbox" {
  instance = aws_instance.linux_jumpbox.id
  vpc      = true
}

output "linux_public_ip" {
  value = aws_instance.linux_jumpbox.public_ip
}


## testBox
resource "aws_instance" "testbox" {
  count         = 2
  ami           = data.aws_ami.CentOS.id
  instance_type = "t3a.nano"
  credit_specification {
    cpu_credits = "standard"
  }
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.jumpbox.id]
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  root_block_device {
    delete_on_termination = "true"
    volume_size           = 12
    volume_type           = "standard"
  }
  tags = merge(
    {
      Name = "testbox ${count.index}"
    },
    var.default_tags,
  )
  lifecycle {
    ignore_changes = [ami]
  }
}
# resource "aws_eip" "linux_jumpbox" {
#   instance = aws_instance.linux_jumpbox.id
#   vpc      = true
# }

output "testbox_ip" {
  value = aws_instance.testbox.*.public_ip
}
