variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "private_web_subnet_ids" {
  type = list(string)
}

variable "sg_web_id" {
  type = string
}

variable "tg_web_arn" {
  type = string
}

