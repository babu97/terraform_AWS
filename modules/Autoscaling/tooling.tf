# launch template for toooling
resource "aws_launch_template" "tooling-launch-template" {
  image_id               = var.ami-web
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.web-sg


  iam_instance_profile {
    name = var.instance_profile
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


  # user_data = filebase64("${path.module}/tooling.sh")
}


# ---- Autoscaling for tooling -----


resource "aws_autoscaling_group" "tooling-asg" {
  name                      = "tooling-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity


  vpc_zone_identifier = var.private_subnets



  launch_template {
    id      = aws_launch_template.tooling-launch-template.id
    version = "$Latest"
  }


  tag {
    key                 = "Name"
    value               = "DEV-tooling"
    propagate_at_launch = true
  }
}
# attaching autoscaling group of  tooling application to internal loadbalancer
# resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
#   autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
#   lb_target_group_arn    = var.tooling-alb-tgt

# }