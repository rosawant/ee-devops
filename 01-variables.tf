##Declare Variables here

variable "aws_access_key" {  }
variable "aws_secret_key" {  }
variable "region" { default = "us-east-1" }
variable "ami" { 
	type = "map" 
	default = {
		us-east-1 = "ami-0083662ba17882949" 
		ap-south-1 = "ami-016ec067d44808c4f"
	} 
}
variable "instance_jenkins" {
	default = "t2.xlarge"
}
variable "instance_app" {
    default = "t2.micro"
}

variable "jenkins_count" {
	default = "1"
}
variable "app_count" {
	default = "1"
}
variable "pubkey" {
	default = "~/.ssh/demo.pem"
}
variable "key" {
        default = "demo"
}

variable "vpc_cidr_subnets" {
  
}

variable "private_cidr_subnets" {
  type    = "list"
  
}

variable "public_cidr_subnets" {
  type    = "list"
 
}

