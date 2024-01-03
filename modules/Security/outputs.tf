output "ALB-sg" {
  value = aws_security_group.ext-alb-sg.id
}


output "IALB-sg" {
    value = aws_security_group.int-alb-sg.id

}


output "bastion-sg" {
 value = aws_security_group.bastion_sg.id

}


output "nginx-sg" {
  value = aws_security_group.nginx-sg.id
}


output "web-sg" {
  value = aws_security_group.webserver-sg.id
}


output "datalayer-sg" {
  value = aws_security_group.datalayer-sg.id
}