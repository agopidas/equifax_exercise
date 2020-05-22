resource "aws_elb" "web_elb" {
  name = "Load-Balancer-elb"

  subnets         = [aws_subnet.public-subnet.id]
  security_groups = [aws_security_group.elb.id]
  #instances       = [aws_instance.web.id]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

}

resource "aws_autoscaling_group" "web_asg" {
  availability_zones = ["us-east-1a"]
  name = "Auto Scaling Group"
  max_size = var.asg_max
  min_size = var.asg_min
  desired_capacity = var.asg_desired
  force_delete = true
  launch_configuration = aws_launch_configuration.web_lc.name
  load_balancers = [aws_elb.web_elb.name]
  vpc_zone_identifier = [aws_subnet.public-subnet.id]
  tag {
    key = "Name"
    value = "web_asg"
    propagate_at_launch = "true"
  }
}

resource "aws_s3_bucket" "equifax-ag-deploy-config" {
  bucket = "equifax-ag-deploy-config"
  acl    = "private"

  tags = {
    Name        = "equifax"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_object" "webserver_script" {
  bucket = aws_s3_bucket.equifax-ag-deploy-config.id
  key    = "webserver.sh"
  source = "./webserver.sh"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  content_type = "text/x-shellscript"
  etag = filemd5("./webserver.sh")
}

data "aws_s3_bucket_object" "webserver_user_data" {
  bucket = aws_s3_bucket.equifax-ag-deploy-config.id
  key   = aws_s3_bucket_object.webserver_script.id
  #key    = "webserver.sh"
}

resource "aws_launch_configuration" "web_lc" {
  name = "Launch Configuration"
  image_id = lookup(var.ami, var.aws_region)
  instance_type = "t1.micro"
  # Security group
  security_groups = [aws_security_group.elb.id]
  user_data     = data.aws_s3_bucket_object.webserver_user_data.body
  key_name      = aws_key_pair.default.id
  associate_public_ip_address = true
}

resource "aws_security_group" "elb" {
  name        = "Security Group ELB"
  description = "Security Group ELB"
  vpc_id      = aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


