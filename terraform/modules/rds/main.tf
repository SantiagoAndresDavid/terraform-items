resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "RDS VPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "RDS IGW"
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "RDS Route Table"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.default.id
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public.*.id)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.default.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.public.*.id

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix  = "rds-sg"
  description  = "Allow MySQL inbound traffic"
  vpc_id       = aws_vpc.default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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

resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = var.tags
}
