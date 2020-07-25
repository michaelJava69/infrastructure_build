provider "aws" {
  region = "${var.region}"
  profile = "dev"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}


terraform {
  backend "s3" {

    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

     bucket         = "s3-bucket-jenkins-terraform"
     key            = "terraform/terraform.tfstate"
     region         = "us-east-2"
     dynamodb_table = "s3-bucket-jenkins-terraform-pipeline-locks"
     encrypt        = true

  }
}

resource "aws_security_group" "sg_jenkins" {
  name = "sg_${var.jenkins_name}"
  description = "Allows all traffic"

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Jenkins JNLP port
  ingress {
    from_port = 50000
    to_port = 50000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = "${file("templates/user_data.tpl")}"
}

resource "aws_instance" "jenkins" {
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.sg_jenkins.name}"]
  ami = "${lookup(var.amis, var.region)}"
  key_name = "${var.key_name}"
  user_data = "${data.template_file.user_data.rendered}"

  tags = {
    Name = "${var.jenkins_name}"
  }

}
