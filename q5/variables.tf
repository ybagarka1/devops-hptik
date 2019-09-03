variable "aws_ubuntu_ami" {
  type = "string"
  default = "ami-0d2692b6acea72ee6"
}

variable "access_key" {
  default = "<your_access_key>"
}

variable "secret_key" {
  default = "<your_secret_key>"
}

variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_one_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet_two_cidr" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "route_table_cidr" {
  default = "0.0.0.0/0"
}

variable "web_ports" {
  default = ["22", "80", "443", "3306"]
}

variable "db_ports" {
  default = ["22", "3306"]
}

variable "images" {
  type = "map"

  default = {
    "ap-south-1" = "ami-0d2692b6acea72ee6"
  }
}
