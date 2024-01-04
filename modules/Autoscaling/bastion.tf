##Launch template for Bastion 

resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
}


resource "aws_launch_template" "bastion-launch-template" {
  image_id               = var.ami-bastion
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.bastion-sg


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


  vpc_zone_identifier = var.public_subnets



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
