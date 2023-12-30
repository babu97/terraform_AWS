#### creating sns topic for all the auto scaling groups
resource "aws_sns_topic" "Ben-sns" {
name = "Default_CloudWatch_Alarms_Topic"
}

resource "aws_autoscaling_notification" "ben_notifications" {
  group_names = [
    aws_autoscaling_group.bastion-asg.name,
    aws_autoscaling_group.nginx-asg.name,
    aws_autoscaling_group.wordpress-asg.name,
    aws_autoscaling_group.tooling-asg.name,
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]


  topic_arn = aws_sns_topic.ben-sns.arn
}


##Launch template for Bastion 

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
}


resource "aws_launch_template" "bastion-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]


  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }


  key_name = var.keypair


  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

    lifecycle {
    create_before_destroy = true
  }
    tag_specifications {
    resource_type = "instance"


   tags = merge(
    var.tags,
    {
      Name = "bastion-launch-template"
    },
  )
  }
   user_data = filebase64("${path.module}/bastion.sh")

}

# ---- Autoscaling for bastion  hosts

resource "aws_autoscaling_group" "bastion-asg" {
  name                      = "bastion-asg"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1


  vpc_zone_identifier = [
    aws_subnet.public_subnet[0].id,
    aws_subnet.public_subnet[1].id
  ]


  launch_template {
    id      = aws_launch_template.bastion-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "bastion-launch-template"
    propagate_at_launch = true
  }


}


# launch template for nginx


resource "aws_launch_template" "nginx-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]


  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }


  key_name =  var.keypair


  placement {
    availability_zone = "random_shuffle.az_list.result"
  }


  lifecycle {
    create_before_destroy = true
  }


  tag_specifications {
    resource_type = "instance"


    tags = merge(
    var.tags,
    {
      Name = "nginx-launch-template"
    },
  )
  }


  user_data = filebase64("${path.module}/nginx.sh")
}
# ------ Autoscslaling group for reverse proxy nginx ---------


resource "aws_autoscaling_group" "nginx-asg" {
  name                      = "nginx-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1


  vpc_zone_identifier = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]


  launch_template {
    id      = aws_launch_template.nginx-launch-template.id
    version = "$Latest"
  }


  tag {
    key                 = "Name"
    value               = "nginx-launch-template"
    propagate_at_launch = true
  }


}


# attaching autoscaling group of nginx to external load balancer
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx-asg.id
  lb_target_group_arn   = aws_lb_target_group.nginx-tgt.arn
}



# launch template for wordpress


resource "aws_launch_template" "wordpress-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]


  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }


  key_name = var.keypair


  placement {
    availability_zone = "random_shuffle.az_list.result"
  }


  lifecycle {
    create_before_destroy = true
  }


  tag_specifications {
    resource_type = "instance"


    tags = merge(
    var.tags,
    {
      Name = "wordpress-launch-template"
    },
  )


  }


  user_data = filebase64("${path.module}/wordpress.sh")
}


# ---- Autoscaling for wordpress application


resource "aws_autoscaling_group" "wordpress-asg" {
  name                      = "wordpress-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier = [


    aws_subnet.private_subnet[0].id,
    aws_subnet.private_subnet[1].id
  ]


  launch_template {
    id      = aws_launch_template.wordpress-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }
}


# attaching autoscaling group of  wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
  lb_target_group_arn   = aws_lb_target_group.wordpress-tgt.arn
}


# launch template for toooling
resource "aws_launch_template" "tooling-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]


  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }


  key_name = var.keypair


  placement {
    availability_zone = "random_shuffle.az_list.result"
  }


  lifecycle {
    create_before_destroy = true
  }


  tag_specifications {
    resource_type = "instance"


  tags = merge(
    var.tags,
    {
      Name = "tooling-launch-template"
    },
  )


  }


  user_data = filebase64("${path.module}/tooling.sh")
}


# ---- Autoscaling for tooling -----


resource "aws_autoscaling_group" "tooling-asg" {
  name                      = "tooling-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1


  vpc_zone_identifier = [


    aws_subnet.private_subnet[0].id,
    aws_subnet.private_subnet[1].id
  ]


  launch_template {
    id      = aws_launch_template.tooling-launch-template.id
    version = "$Latest"
  }


  tag {
    key                 = "Name"
    value               = "tooling-launch-template"
    propagate_at_launch = true
  }
}
# attaching autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
  lb_target_group_arn   = aws_lb_target_group.tooling-tgt.arn

}

