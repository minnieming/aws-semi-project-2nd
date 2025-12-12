output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_bastion.id,
    aws_subnet.public_az2.id
  ]
}

output "public_bastion_subnet_id" {
  value = aws_subnet.public_bastion.id
}

output "private_web_subnet_ids" {
  value = [
    aws_subnet.private_web_az1.id,
    aws_subnet.private_web_az2.id
  ]
}

output "private_db_subnet_ids" {
  value = [
    aws_subnet.private_db_az1.id,
    aws_subnet.private_db_az2.id
  ]
}

