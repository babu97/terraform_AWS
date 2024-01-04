# security group for alb, to allow acess from any where for HTTP and HTTPS traffic

resource "aws_security_group_rule" "inbound-nginx-http" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["ext-alb-sg"].id
  security_group_id        = aws_security_group.DEV["nginx-sg"].id
}


resource "aws_security_group_rule" "inbound-bastion-ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["bastion-sg"].id
  security_group_id        = aws_security_group.DEV["nginx-sg"].id
}




resource "aws_security_group_rule" "inbound-ialb-https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["nginx-sg"].id
  security_group_id        = aws_security_group.DEV["int-alb-sg"].id
}




resource "aws_security_group_rule" "inbound-web-https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["int-alb-sg"].id
  security_group_id        = aws_security_group.DEV["webserver-sg"].id
}


resource "aws_security_group_rule" "inbound-web-ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["bastion_sg"].id
  security_group_id        = aws_security_group.DEV["webserver-sg"].id
}



resource "aws_security_group_rule" "inbound-nfs-port" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["webserver-sg"].id
  security_group_id        = aws_security_group.DEV["datalayer-sg"].id
}


resource "aws_security_group_rule" "inbound-mysql-bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["bastion_sg"].id
  security_group_id        = aws_security_group.DEV["datalayer-sg"].id
}


resource "aws_security_group_rule" "inbound-mysql-webserver" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.DEV["webserver-sg"].id
  security_group_id        = aws_security_group.DEV["datalayer-sg"].id
}
