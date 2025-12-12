output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "tg_web_arn" {
  value = aws_lb_target_group.web.arn
}

