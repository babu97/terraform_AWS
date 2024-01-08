
# This section will create the subnet group for the RDS  instance using the private subnet
resource "aws_db_subnet_group" "dev-rds" {
  name        = "dev-rds-subnet-group"
  description = "RDS subnet group for development environment"

  subnet_ids = var.private_subnets
    # Add other subnet IDs as needed
  

  tags = merge(
    var.tags,
    {
      Name = var.name
    },
  )
}


# create the RDS instance with the subnets group
resource "aws_db_instance" "dev-rds" {

  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "dev"
  username               = "admin"
  password               = "kipkulei123"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.dev-rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db-sg
  multi_az               = "true"
}
