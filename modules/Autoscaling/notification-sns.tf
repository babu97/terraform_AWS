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


  topic_arn = aws_sns_topic.Ben-sns.arn
}











