resource "aws_autoscaling_group" "web_api_asg" {
  name = "${var.prefix}-web-api-asg"
  max_size = 4
  min_size = 2
  health_check_grace_period = 100
  health_check_type = "ELB"
  desired_capacity = 2
  force_delete = true
  vpc_zone_identifier = [var.private_subnets[0], var.private_subnets[1]]

  launch_template {
    id = var.launch_template_id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key = "Name"
    value = "${var.prefix}-web-api-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "target_tracking" {
  name = "${var.prefix}-web-api-asg-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web_api_asg.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}