provider "aws" {
    region = "ap-south-1"
    profile = "azeem"
}

resource "aws_db_instance" "mydb" {

  engine            = "mysql"
  engine_version    = "5.7.30"
  instance_class    = "db.t2.micro"
  allocated_storage = 10

  name     = "RDSDB"
  username = "azeem"
  password = "azeem123"
  port     = "3306"
  publicly_accessible = true

  iam_database_authentication_enabled = true

  parameter_group_name = "default.mysql5.7"

  tags = {
      Name = "RDSins"
  }
}

output "url" {
    value = aws_db_instance.mydb.address
}
