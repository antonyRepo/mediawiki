# UserData for EC2 that builds the stack
data "template_file" "userdata" {
  template = "${file("${path.module}/user_data.sh.tpl")}"

  vars = {
    "wiki_version" = "${var.wiki_version}"
  }
}

# Launch Configuration
resource "aws_launch_configuration" "media-wiki-lc" {
  count = var.keep

  lifecycle {
    create_before_destroy = true
  }

  key_name       = var.keys
  name_prefix    = "media-wiki-${var.color}"
  image_id       = var.ami_id
  instance_type  = var.instance_type
  security_groups= [ var.security_groups_ec2 ]
  iam_instance_profile = var.iam_role
  user_data            = "${data.template_file.userdata.rendered}"

  depends_on = ["aws_elb.media-wiki-elb"]
}

#Auto Scaling Group
resource "aws_autoscaling_group" "media-wiki-asg" {
  count = var.keep

  lifecycle {
    create_before_destroy = true
  }

  name             = "asg-${aws_launch_configuration.media-wiki-lc[count.index].name}"
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_size

  wait_for_capacity_timeout = "12m"

  health_check_type         = "ELB"
  health_check_grace_period = 600
  load_balancers            = ["${aws_elb.media-wiki-elb[count.index].name}"]
  launch_configuration      = "${aws_launch_configuration.media-wiki-lc[count.index].id}"
  vpc_zone_identifier       = [ var.subnets ]
  termination_policies      = ["OldestInstance"]

  tag {
    key = "Name"
    value = "media-wiki-${var.color}"
    propagate_at_launch = true
  }

  depends_on = [ "aws_launch_configuration.media-wiki-lc" ]
}

# ASG autoscaling policy
resource "aws_autoscaling_policy" "media-wiki-asg-policy" {
  count = var.keep

  lifecycle {
    create_before_destroy = true
  }

  name               = "media-wiki-${var.color}-asg-policy"
  scaling_adjustment = 1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300
  autoscaling_group_name = "${aws_autoscaling_group.media-wiki-asg[count.index].name}"
}