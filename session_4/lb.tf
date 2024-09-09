resource "aws_lb" "this" {
  name            = format("%s-lb", var.prefix)
  internal        = false
  security_groups = [aws_security_group.lb.id]
  subnets         = aws_subnet.public_subnets[*].id
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = format("%s-lb-tg", var.prefix)
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200,302"
    path                = "/users"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_security_group" "lb" {
  name   = format("%s-lb-sg", var.prefix)
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    self      = true
  }

  egress {
    description      = "Allow outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}