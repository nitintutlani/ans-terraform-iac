data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]

  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-linux-extras
              amazon-linux-extras install -y nginx1
              systemctl start nginx
              systemctl enable nginx
              echo '<html><body><h1>Hello, World! from EC2 instance #${count.index + 1}.</h1></body></html>' > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-nginx-${count.index}"
  }
}

resource "aws_lb" "this" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "this" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this[count.index].id
  port             = 80
}
