## So the Solution I have gone for for a first stab is

```
Baking of an image of an Ubuntu Server with Docker together with docker useradmin
https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard: us-east-1 under MyImages

```

```
Creating a Jenkins Docker image customized to be configured with plaugin and be ready to use with user admin

Using Terraform to deploy backed image and deploy Customized Docker image

Baked image = ubuntu-xenial-docker-ce-base 1592679374 - ami-0f64308c64472f493

```
```

How to use mfa Assumed role script : start_aws_profile.sh 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Step 1:
=======

How to set up ~/.aws/config
---------------------------
[profile default]
#region = eu-west-2
region = us-east-2

[profile dev]
region = us-east-2
#region = eu-west-2
source_profile = mfa
role_arn = arn:aws:iam::904806826062:role/OrganizationEngineerAccessRole

How to set up ~/.aws/credentials
---------------------------------

[default]
aws_access_key_id = <default key id>
aws_secret_access_key = <default access key>

[mfa]


Step 2:
=======

export AWS_PROFILE=dev
export AWS_SDK_LOAD_CONFIG=1


Step 3:
=======

./start_aws_profile.sh mfa michalugbechie <mfa number from fob>

Your ~/.aws/credentials file will be automatically updated with assumed role key id and access key


```





```
# to do
```
Tying all three together under a build script

```
