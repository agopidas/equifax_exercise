resource "aws_instance" "bastion_server" {
  ami                         = lookup(var.ami, var.aws_region)
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.default.id
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name    = "Bastion host"
    Project = "equifax"
  }
}

resource "aws_security_group" "bastion" {
  name        = "Bastion host of VPC"
  description = "Allow SSH access to bastion host and outbound internet access"
  vpc_id      = aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project = "equifax"
  }
}

resource "aws_security_group_rule" "ssh" {
  protocol          = "TCP"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "internet" {
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}