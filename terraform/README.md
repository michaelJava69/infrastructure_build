# Terraformed Jenkins

Deploy Jenkins 2.0 in a [docker container](https://hub.docker.com/r/library/jenkins/tags/) on an AWS EC2 instance using [Terraform](https://www.terraform.io/).

https://hub.docker.com/r/jenkins/jenkins/


## Usage

scripts
```

You need to change the default values of `s3_bucket` and `key_name` terraform variables defined in `variables.tf` or set them via environment variables:
```
$ export TF_VAR_s3_bucket=<your s3 bucket>  i.e TF_VAR_s3_bucket=s3-bucket-jenkins-terraform
$ export TF_VAR_key_name=<your keypair name>   i.e TF_VAR_table_name=s3-bucket-jenkins-terraform-locks
```

In stage folder

### Run 'terraform init'

### Run 'terraform plan'

### Run 'terraform apply'

### Run 'terraform destroy'

     

Upon completion, terraform will output the DNS name of Jenkins, e.g.:
```
jenkins_public_dns = [ ec2-54-235-229-108.compute-1.amazonaws.com ]
```
You can then reach Jenkins via your browser at `http://ec2-54-235-229-108.compute-1.amazonaws.com`.
