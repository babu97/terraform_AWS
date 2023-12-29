resource "aws_lb" "ext-alb" {
  name     = "ext-alb"
  internal = false
  security_groups = [
    aws_security_group.ext-alb-sg.id,
  ]


  subnets = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]
  enable_deletion_protection = true



   tags = merge(
    var.tags,
    {
      Name = "ACS-ext-alb"
    },
  )


  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "nginx-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "nginx-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
}

