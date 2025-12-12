# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  vpc_id      = var.vpc_id
  description = "ALB security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]   # 내 IP만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Bastion SG
resource "aws_security_group" "bastion" {
  name        = "${var.name}-bastion-sg"
  vpc_id      = var.vpc_id
  description = "Bastion host SG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]   # SSH는 내 IP만
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web SG
resource "aws_security_group" "web" {
  name        = "${var.name}-web-sg"
  vpc_id      = var.vpc_id
  description = "Web ASG SG"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]  # ALB에서 80 허용
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]  # Bastion → Web SSH
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS SG
resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  vpc_id      = var.vpc_id
  description = "RDS SG"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]   # Web → DB 연결 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

