output "ALB-sg" {
  value = aws_security_group.DEV["ext-alb-sg"].id
}


output "IALB-sg" {
    value = aws_security_group.DEV["int-alb-sg"].id

}


output "bastion-sg" {
 value = aws_security_group.DEV["bastion_sg"].id

}


output "nginx-sg" {
  value = aws_security_group.DEV["nginx-sg"].id
}


output "web-sg" {
  value = aws_security_group.DEV["webserver-sg"].id
}


output "datalayer-sg" {
  value = aws_security_group.DEV["datalayer-sg"].id
}