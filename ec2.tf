

locals {
  instance_profile = aws_iam_instance_profile.instance_profile.name
}

data "aws_ami" "ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "nginx-sg" {
  name        = "nginx-sg"
  description = "Allow alb inbound traffic on port 80"
  vpc_id      = local.vpc_id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-sg"
  }
}


resource "aws_security_group_rule" "nginx-ingress-http-inboudrule" {

  security_group_id        = aws_security_group.nginx-sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb-sg.id # alb id 
}


resource "aws_instance" "nginx-instance" {
  count                  = length(local.azs)
  ami                    = data.aws_ami.ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  user_data              = file("${path.module}/templates/nginx.sh")
  iam_instance_profile   = local.instance_profile
  subnet_id              = aws_subnet.private.*.id[count.index]

  tags = {
    Name = "nginx-instance"
  }
  root_block_device {
    volume_type = "gp3"
    volume_size = 10
    encrypted  = true

  }
}

resource "aws_lb_target_group_attachment" "this" {
count = length(aws_instance.nginx-instance)
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.nginx-instance[count.index].id
  port             = 80
}