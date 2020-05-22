variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/21"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = {
        us-east-1 = "ami-0c2a1acae6667e438"
    }
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "./keys/region-nyc.pub"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default = "1"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default = "1"
}