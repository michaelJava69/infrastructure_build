variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique.  : terraform-s3-bucket-jenkins"
  type        = string
  default = "terraform-s3-bucket-jenkins-pipeline"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account.  : terraform-s3-bucket-jenkins-locks"
  type        = string
  default = "terraform-s3-bucket-jenkins-pipeline-locks"
}
