resource "aws_db_instance" "poc_screena" {
  identifier           = "pocscreenard"
  instance_class       = "db.t3.micro"
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "14"
  username             = "edu"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.poc_screena.name
  vpc_security_group_ids = [aws_security_group.allow_pgsql.id]
  parameter_group_name   = aws_db_parameter_group.poc_screena.name
  publicly_accessible = false
  skip_final_snapshot = true
  tags = {
    Name = "poc_screena_rds"
  }
}

resource "aws_db_parameter_group" "poc_screena" {
  family = "postgres14"
  tags = {
    Name = "poc_screena_db_parameter_group"
  }
  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "poc_screena" {
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id]

  tags = {
    Name = "poc_screena_subnet_group"
  }
}