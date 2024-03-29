data "aws_availability_zones" "availability_zones" {}

resource "aws_vpc" "hptik" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "devops-hptik-vpc"
  }
}

#create public subnet
resource "aws_subnet" "hptik" {
  vpc_id                  = "${aws_vpc.hptik.id}"
  cidr_block              = "${var.subnet_one_cidr}"
  availability_zone       = "${data.aws_availability_zones.availability_zones.names[0]}"
  map_public_ip_on_launch = true
}

#create private subnet one
resource "aws_subnet" "hptik_subnet_one" {
  vpc_id            = "${aws_vpc.hptik.id}"
  cidr_block        = "${element(var.subnet_two_cidr, 0)}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[0]}"
}

#create private subnet two
resource "aws_subnet" "hptik_subnet_two" {
  vpc_id            = "${aws_vpc.hptik.id}"
  cidr_block        = "${element(var.subnet_two_cidr, 1)}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[1]}"
}

#create internet gateway
resource "aws_internet_gateway" "hptik_gw" {
  vpc_id = "${aws_vpc.hptik.id}"
}

#create public route table (assosiated with internet gateway)
resource "aws_route_table" "hptik_public_route" {
  vpc_id = "${aws_vpc.hptik.id}"

  route {
    cidr_block = "${var.route_table_cidr}"
    gateway_id = "${aws_internet_gateway.hptik_gw.id}"
  }
}

#create private subnet route table
resource "aws_route_table" "hptik_private_route" {
  vpc_id = "${aws_vpc.hptik.id}"
}

#create default route table
resource "aws_default_route_table" "hptik" {
  default_route_table_id = "${aws_vpc.hptik.default_route_table_id}"
}

#assosiate public subnet with public route table
resource "aws_route_table_association" "hptik_public_association" {
  subnet_id      = "${aws_subnet.hptik.id}"
  route_table_id = "${aws_route_table.hptik_public_route.id}"
}

#assosiate private subnets with private route table
resource "aws_route_table_association" "hptik_subnet_one" {
  subnet_id      = "${aws_subnet.hptik_subnet_one.id}"
  route_table_id = "${aws_route_table.hptik_private_route.id}"
}

resource "aws_route_table_association" "hptik_subnet_two" {
  subnet_id      = "${aws_subnet.hptik_subnet_two.id}"
  route_table_id = "${aws_route_table.hptik_private_route.id}"
}

#create security group for web
resource "aws_security_group" "hptik_web" {
  name        = "web_security_group"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.hptik.id}"
}

#create security group ingress rule for web
resource "aws_security_group_rule" "hptik_ingress" {
  count             = "${length(var.web_ports)}"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.web_ports, count.index)}"
  to_port           = "${element(var.web_ports, count.index)}"
  security_group_id = "${aws_security_group.hptik_web.id}"
}

#create security group egress rule for web
resource "aws_security_group_rule" "hptik_egress" {
  count             = "${length(var.web_ports)}"
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.web_ports, count.index)}"
  to_port           = "${element(var.web_ports, count.index)}"
  security_group_id = "${aws_security_group.hptik_web.id}"
}

#create security group for db
resource "aws_security_group" "hptik_db" {
  name        = "db_security_group"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.hptik.id}"
}

#create security group ingress rule for db
resource "aws_security_group_rule" "hptik_db_ingress" {
  count             = "${length(var.db_ports)}"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.db_ports, count.index)}"
  to_port           = "${element(var.db_ports, count.index)}"
  security_group_id = "${aws_security_group.hptik_db.id}"
}

#create security group egress rule for db
resource "aws_security_group_rule" "hptik_db_egress" {
  count             = "${length(var.db_ports)}"
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.db_ports, count.index)}"
  to_port           = "${element(var.db_ports, count.index)}"
  security_group_id = "${aws_security_group.hptik_db.id}"
}

resource "aws_instance" "hptik_web" {
  ami                    = "${lookup(var.images,var.region)}"
  instance_type          = "t2.micro"
  key_name               = "ybagarka"                             #make sure you have your_private_ket.pem file
  vpc_security_group_ids = ["${aws_security_group.hptik_web.id}"]
  subnet_id              = "${aws_subnet.hptik.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /var/www/html/",            #install apache, mysql client, php
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo service httpd start",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo yum install -y mysql php php-mysql",
    ]
  }

  provisioner "file" {
    source      = "index.php"               #copy the index file form local to remote
    destination = "/var/www/html/index.php"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = ""

    #copy <your_private_key>.pem to your local instance home directory
    #restrict permission: chmod 400 <your_private_key>.pem
    private_key = "${file("/tmp/ybagarka.pem")}"
  }
}

#create aws rds subnet groups
resource "aws_db_subnet_group" "hptik_db_subnet" {
  name       = "mydbsg"
  subnet_ids = ["${aws_subnet.hptik_subnet_one.id}", "${aws_subnet.hptik_subnet_two.id}"]
}

#create aws mysql rds instance
resource "aws_db_instance" "hptik_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  port                   = 3306
  vpc_security_group_ids = ["${aws_security_group.hptik_db.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.hptik_db_subnet.name}"
  name                   = "mydb"
  identifier             = "mysqldb"
  username               = "admin_user"
  password               = "hptik-123"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
}
