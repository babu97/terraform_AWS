
#Output DNS NAME and Target_Grouparn 
output "alb_dns_name" {
  value = aws_lb.ext-alb.dns_name
}


output "alb_target_group_arn" {
  value = aws_lb_target_group.nginx-tgt.arn
}

#Output DNS NAME and Target_Grouparn for internal load balancer


output "int_dns_name" {
  value = aws_lb.ialb.dns_name
}


output "nginx-tgt" {
  description = "External Load balancaer target group"
  value       = aws_lb_target_group.nginx-tgt.arn
}
output "tooling-tgt" {
  description = "Tooling target group"
  value       = aws_lb_target_group.tooling-tgt.arn

}
output "wordpress-tgt" {
  description = "wordpress target group"
  value       = aws_lb_target_group.wordpress-tgt.arn
}



