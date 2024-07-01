# Create a VPC
resource "aws_vpc" "poc_screena" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "poc_screena"
  }
}

resource "aws_internet_gateway" "poc_screena" {
  vpc_id = aws_vpc.poc_screena.id

  tags = {
    Name = "poc_screena_internet_gateway"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.poc_screena.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = local.av_zone_west1a
  map_public_ip_on_launch = true

  tags = {
    Name = "poc_screena_subnet_public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.poc_screena.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.poc_screena.id
  }

  tags = {
    Name = "poc_screena_route_table_public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.poc_screena.id

  tags = {
    Name = "poc_screena_route_table_private_a"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.poc_screena.id

  tags = {
    Name = "poc_screena_route_table_private_b"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.poc_screena.id

  tags = {
    Name = "poc_screena_route_table_private_"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.c.id
  route_table_id = aws_route_table.private_c.id
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.poc_screena.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = local.av_zone_west1a

  tags = {
    Name = "poc_screena_subnet_a"
  }
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.poc_screena.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = local.av_zone_west1b

  tags = {
    Name = "poc_screena_subnet_b"
  }
}

resource "aws_subnet" "c" {
  vpc_id            = aws_vpc.poc_screena.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = local.av_zone_west1c

  tags = {
    Name = "poc_screena_subnet_c"
  }
}


#data "aws_ami" "ubuntu" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#  }
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#
#  owners = ["099720109477"] # Canonical
#}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
 
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240620.0-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_network_interface" "primary" {
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "primary_interface"
  }
}

resource "aws_instance" "poc_screena" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.poc_screena.key_name
  user_data_replace_on_change = true

  network_interface {
    network_interface_id = aws_network_interface.primary.id
    device_index         = 0
  }

  tags = {
    Name = "poc_screena_aws_instance_test_client_db"
  }

  iam_instance_profile = aws_iam_instance_profile.session_manager_profile.name
}


resource "aws_eip" "secondary_public" {
  network_interface = aws_network_interface.primary.id
  domain            = "vpc"
}

resource "aws_key_pair" "poc_screena" {
  key_name   = "deployer-key-perso-fred"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGQ2bmnH4s07cEYnZninY4NSiAENimTSV/YdjR+grIme3QMq5WH9ixJ1L8/pvqMdsFB157UaoloC5b6JHFGdIQRsjC7u94HNU4ntoiJ512Alh5It9KEj/jvzo6oVGTWY/mpv9yjtxpMGNS1Ue63rCEfDsbdC71lb6mpbQ5F4mWVBJ4GAOPsfp+i8Z3K2UOR1fTIyM/gBMxirgA/sykDOzYEGKMzV/O1jSDgijsoxil1FjKqEvdTarOnGJN+tkG/HR7hmsIjMD8c1xagJXcD2EMdMy5VXx26MdG8rzs/Fn1dSd5wvd+PHiG6hifGT1I7gBR61qVViqyZloxWwYrXN0EfI51131Lf8Aj59Q0JJosHtOWvBOflOgyoSA6L54DVj24o8+BiHkf+UVvxn1iY58tXLXofSBF2JbrX2Qy+UEK8OHjFj9CvdYRMsG0QYKTtaKmiZnsH1wXEuoBGfNj8VT0NAOX8O7rJVwyrfO5iYgioFY4UZHbVju+NB+1zOkJMoul3j7oe4b7C8PvuRDveySE401gikIkwbqwzA6xbePBvoMyXrgq36hEuZpA7iIedc0iBfyD6CQOzk2mr3aus/D/Dbr5IvzrBJVRjGe7pkm9okuXBQw30+t/fXId+2qFtd6QP8n/JjVM01/EEd6JongT2FU9se4fdYqsZnecDfbO8w== fcardoso@ITEM-S87654"
}

resource "aws_security_group" "allow_pgsql" {
  name        = "allow_pgsql"
  description = "Allow PGSQL proto inbound traffic"
  vpc_id      = aws_vpc.poc_screena.id

  ingress {
    description = "PGSQL proto from anywhere"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.7.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_https_inbound" {
  name        = "allow_https_inbound"
  description = "Allow HTTPS proto inbound traffic"
  vpc_id      = aws_vpc.poc_screena.id

  ingress {
    description = "HTTPS proto from SSM endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.7.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.poc_screena.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
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

