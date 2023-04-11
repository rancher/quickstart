resource "aws_elb" "opni-lb" {
  name            = "${var.prefix}-opni-lb"
  subnets         = [aws_subnet.opni_subnet.id]
  security_groups = [aws_security_group.opni_sg_allowall.id]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9090"
    interval            = 30
  }

  listener {
    instance_port     = 32090
    instance_protocol = "tcp"
    lb_port           = 9090
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 32000
    instance_protocol = "tcp"
    lb_port           = 4000
    lb_protocol       = "tcp"
  }

  instances = [
    aws_instance.opni_server[0].id,
    aws_instance.opni_server[1].id,
    aws_instance.opni_server[2].id
  ]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.prefix}-opni-lb"
  }
}
