provider "aws"{
    region = "eu-central-1"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name: "${var.env} -vpc"
    }
}

resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.avail

    tags = {
        Name: "${var.env} -subnet1"
    }
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name: "${var.env} -internet-gateway"
    }
}

resource "aws_route_table" "my_rtb" {
    vpc_id = aws_vpc.my_vpc.id


    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }

    tags = {
        Name: "${var.env } - routetable"
    }
}

resource "aws_security_group" "my_security" {
   name = "firewall-rules"
   vpc_id = aws_vpc.my_vpc.id


   ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = [var.my_ip, var.jenkins_ip]
    protocol = "TCP"
   } 

   ingress {
    from_port = 8080
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "TCP"
   }

   egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
   }

   tags = {
    Name: "${var.env} -security group"
   }
}

data "aws_ami" "instance_ami" {
    most_recent =true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-kernel-*-x86_64-gp2"]
    }
}
resource "aws_instance" "my_instance" {
    ami = data.aws_ami.instance_ami.id
    subnet_id = aws_subnet.my_subnet.id
    vpc_security_group_ids = [aws_security_group.my_security.id]
    availability_zone = var.avail
    associate_public_ip_address = true
    key_name = "testkey"
    instance_type = "t2.micro"

    tags = {
        Name: "${var.env} -instance"
    }

    user_data = file("script.sh")

}

