# EC2 alarm for AutoScaling
resource "aws_cloudwatch_metric_alarm" "media-wiki-cpu-cw" {
    count               = var.keep
    alarm_name          = "media-wiki-cpu-cw-${var.color}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "300"
    statistic           = "Average"
    threshold           = "70"
    actions_enabled     = "false"

    dimensions = {
        AutoScalingGroupName = "${aws_autoscaling_group.media-wiki-asg[count.index].name}"
    }
}