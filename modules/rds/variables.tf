variable "name" {
  type = string
}

variable "private_db_subnet_ids" {
  type = list(string)
}

variable "sg_rds_id" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

