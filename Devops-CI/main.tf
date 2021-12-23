terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"

    }
  }

  backend "s3" {
    bucket = "dfarlow-useast1"
    key    = "devops-infra/tf-state"
    region = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"

}

# create vpc

resource "aws_vpc" "devops-VPC" {
  cidr_block = var.cidr_block[0]
  tags = {
    Name = "Devops-VPC"
  }

}

# create public subnet
resource "aws_subnet" "devops-subnet-ext" {
  vpc_id     = aws_vpc.devops-VPC.id
  cidr_block = var.cidr_block[1]
  tags = {
    Name = "Devops-subnet-ext-1"
  }
}

# create internet gateway
resource "aws_internet_gateway" "devops-IntGW" {
  vpc_id = aws_vpc.devops-VPC.id
  tags = {
    Name = "Devops-igw"
  }

}

#create security group
resource "aws_security_group" "devops_sg" {


  name        = "Devops-SG"
  vpc_id      = aws_vpc.devops-VPC.id
  description = "Security Group for devops infrastruce to allow ec2 to connect to vpc"

  dynamic "ingress" {
    iterator = port
    for_each = var.ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Devops-sg"
  }
}


resource "aws_route_table" "devops-rt" {
  vpc_id = aws_vpc.devops-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-IntGW.id

  }
  tags = {
    Name = "Devops-routetable"
  }
}


resource "aws_route_table_association" "devops_asso" {
  subnet_id      = aws_subnet.devops-subnet-ext.id
  route_table_id = aws_route_table.devops-rt.id

}


resource "aws_instance" "jenkins_server" {
  ami                         = var.ami
  instance_type               = "t2.small"
  key_name                    = "devops-kp"
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  subnet_id                   = aws_subnet.devops-subnet-ext.id
  associate_public_ip_address = true
  user_data                   = file("../user_data/install_jenkins.sh")

  tags = {
    Name = "jenkins_server"
  }

}


resource "aws_instance" "ansibile_controller" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "devops-kp"
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  subnet_id                   = aws_subnet.devops-subnet-ext.id
  associate_public_ip_address = true
  user_data                   = file("../user_data/install_ansible.sh")

  tags = {
    Name = "ansibile_controller"
  }

}


resource "aws_instance" "ansibile_managed_node" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "devops-kp"
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  subnet_id                   = aws_subnet.devops-subnet-ext.id
  associate_public_ip_address = true
  user_data                   = file("../user_data/setup_ansible_manage.sh")

  tags = {
    Name = "ansibile_managed_node"
  }

}



resource "aws_instance" "docker_host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "devops-kp"
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  subnet_id                   = aws_subnet.devops-subnet-ext.id
  associate_public_ip_address = true
  user_data                   = file("../user_data/setup_docker.sh")

  tags = {
    Name = "docker_host"
  }

   lifecycle {
    ignore_changes = [user_data]
  }


}


resource "aws_instance" "nexus" {
  ami                         = var.ami
  instance_type               = var.instance_type_nexus
  key_name                    = "devops-kp"
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  subnet_id                   = aws_subnet.devops-subnet-ext.id
  associate_public_ip_address = true
  user_data                   = file("../user_data/install_sona.sh")

  tags = {
    Name = "nexus_server"
  }

   lifecycle {
    ignore_changes = [user_data]
  }


}