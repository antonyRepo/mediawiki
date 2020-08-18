# Elastic Load balancer
resource "aws_elb" "media-wiki-elb" {
  count = var.keep

  lifecycle {
    create_before_destroy = true
  }

  name            = "media-wiki-${var.color}"
  security_groups = [ var.security_groups_elb ]
  subnets         = [ var.subnets ]

  # ELB listerners that forwards request from ELB port to Instance port
  listener {
    instance_port     = 80
    instance_protocol = "TCP"
    lb_port     = 80
    lb_protocol = "TCP"
  }

  # ELB health check on EC2
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    interval = 30
    target   = "HTTP:80/index.html"
    timeout  = 5
  }

  tags = {
    Name = "media-wiki-${var.color}"
    OwnerContact = "antonymanoj1994@gmail.com"
  }
}