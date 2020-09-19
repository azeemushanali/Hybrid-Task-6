provider "aws" {
    region = "ap-south-1"
    profile = "azeem"
}

resource "aws_vpc" "tf_vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc-tf"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = var.aws_subnet_cidr[0]
  availability_zone = var.aws_availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    Name = var.aws_subnet_name[0]
  }
}

resource "aws_subnet" "tf_subnet2" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = var.aws_subnet_cidr[1]
  availability_zone = var.aws_availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    Name = var.aws_subnet_name[1]
  }
}

resource "aws_internet_gateway" "tf_gw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = var.aws_ig_name
  }
}

resource "aws_route_table" "tf_rt" {
    vpc_id = aws_vpc.tf_vpc.id

    route {
        gateway_id = aws_internet_gateway.tf_gw.id
        cidr_block = var.allow_all
    }

    tags = {
        Name = var.route_table_name
    }
}

resource "aws_route_table_association" "tf_sub_a" {
    subnet_id      = aws_subnet.tf_subnet.id
    route_table_id = aws_route_table.tf_rt.id
}

resource "aws_route_table_association" "tf_sub_b" {
    subnet_id      = aws_subnet.tf_subnet2.id
    route_table_id = aws_route_table.tf_rt.id
}

resource "aws_security_group" "tf_sg2" {
  depends_on = [ aws_vpc.tf_vpc ]
  name        = var.aws_sg_name
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ var.allow_all ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ var.allow_all ]
  }

  tags = {
    Name = var.aws_sg_tag
  }
}

resource "aws_db_subnet_group" "subnetdb" {
  name       = var.aws_db_subnet_name
  subnet_ids = [ aws_subnet.tf_subnet.id , aws_subnet.tf_subnet2.id ]
}

resource "aws_db_instance" "mydb" {
  
  identifier        = var.db_identifier
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_storage

  db_subnet_group_name    = aws_db_subnet_group.subnetdb.id

  name     = var.database_name
  username = var.database_username
  password = var.database_password
  port     = var.database_port

  vpc_security_group_ids = [ aws_security_group.tf_sg2.id ]

  publicly_accessible = var.db_public_accessible

  iam_database_authentication_enabled = true

  parameter_group_name = var.db_parameter_name

  tags = {
      Name = var.db_tag
  }
}

output "url" {
     value = aws_db_instance.mydb.address
 }





variable "aws_subnet_cidr" {
    default = [ "192.168.0.0/24" , "192.168.1.0/24" ]
}

variable "aws_availability_zone" {
    default = [ "ap-south-1a" , "ap-south-1b" ]
}

variable "aws_subnet_name" {
    default = [ "subnet-1" , "subnet-2" ]
}

variable "aws_ig_name" {
    type    = string
    default = "my-ig"
}

variable "allow_all" {
    type    = string
    default = "0.0.0.0/0"
}

variable "route_table_name" {
    type    = string
    default = "my_rt2"
}

variable "aws_sg_name" {
    type    = string
    default = "db_sg"
}

variable "aws_sg_tag" {
    type    = string
    default = "mysql_sg"
}

variable "aws_db_subnet_name" {
    type    = string
    default = "db-subnet"
}

variable "db_identifier" {
    type    = string
    default = "mydb-tf"
}

variable "db_engine" {
    type    = string
    default = "mysql"
}

variable "db_engine_version" {
    type    = string
    default = "5.7.30"
}

variable "db_instance_class" {
    type    = string
    default = "db.t2.micro"
}

variable "db_storage" {
    default = 10
}

variable "database_name" {
    type    = string
    default = "azeemdb"
}

variable "database_username" {
    type    = string
    default = "azeem"
}

variable "database_password" {
    type    = string
    default = "azeem1234"
}

variable "database_port" {
    type    = string
    default = "3306"
}

variable "db_public_accessible" {
    type = bool
    default = true
}

variable "db_parameter_name" {
    type    = string
    default = "default.mysql5.7"
}

variable "db_tag" {
    type    = string
    default = "azeem"
}



variable "image_name" {
    type    = string
    default = "wordpress"
}

variable "container_name" {
    type    = string
    default = "my-wp-tf"
}

variable "loadbalancer_name" {
    type    = string
    default = "wp-loadbalancer-tf"
}

