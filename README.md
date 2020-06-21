## So the Solution I have gone for for a first stab is

```
Backing an image of an Ubuntu Server with Docker together with docker useradmin
https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard: us-east-1 under MyImages

```

```
Creating a Jenkins Docker image customized to be configured with plaugin and be ready to use with user admin

Using Terraform to deploy backed image and deploy Customized Docker image

Baked image = ubuntu-xenial-docker-ce-base 1592679374 - ami-0f64308c64472f493

```

# to do
```
Tying all three together under a build script

```
