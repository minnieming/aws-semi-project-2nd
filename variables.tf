variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "project_name" {
  type    = string
  default = "test"
}

variable "my_ip_cidr" {
  type        = string
  description = "Your IP for SSH & ALB access"
}

variable "key_name" {
  type = string
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_type_web" {
  type    = string
  default = "t3.micro"
}

variable "instance_type_bastion" {
  type    = string
  default = "t3.micro"
}

