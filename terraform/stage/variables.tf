
variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "availability_zone" {
  description = "The availability zone"
  default = "us-east-1b"
}

variable "jenkins_name" {
  description = "The name of the Jenkins server."
  default = "Baked Jenkins via TF"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the Weave ECS AMIs: https://github.com/weaveworks/integrations/tree/master/aws/ecs."
  type = map(string)
  default = {
    us-east-1 = "ami-0f64308c64472f493"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "Michael-N-Virginia"
  description = "SSH key name in your AWS account for AWS instances."
}

variable "s3_bucket" {
  default = "terraform-s3-bucket-jenkins"
  description = "S3 bucket where remote state and Jenkins data will be stored."
}
