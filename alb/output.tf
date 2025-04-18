output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.web_api_tg.arn
}

output "alb_arn" {
  value = aws_lb.alb.arn
}