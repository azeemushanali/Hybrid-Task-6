provider "aws" {
    region = "ap-south-1"
    profile = "azeem"
}

resource "aws_db_instance" "mydb" {

  engine            = "mysql"
  engine_version    = "5.7.30"
  instance_class    = "db.t2.micro"
  allocated_storage = 10

  name     = "aksdb"
  username = "diyaksh"
  password = "whoaks1234"
  port     = "3306"
  publicly_accessible = true

  iam_database_authentication_enabled = true

  parameter_group_name = "default.mysql5.7"

  tags = {
      Name = "Akashi"
  }
}

output "url" {
    value = aws_db_instance.mydb.address
}