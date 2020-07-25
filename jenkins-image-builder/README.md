# Automated Jenkins setup with Docker and Terraform

Source code in this repository is used for set of Jenkins tutorials on [Popularowl](https://www.popularowl.com).

* [Installing, configuring and running JenkinsCI server](https://www.popularowl.com/blog/installing-configuring-jenkinsci-nginx)
* [Automating Jenkins install and configuration with Docker and Terraform](https://www.popularowl.com/jenkins/automating-jenkins-install-docker-terraform)
* [Jenkins plugins and plugin management](https://www.popularowl.com/jenkins/jenkins-plugins-and-plugin-management)

## How to use

 
```
### Build Docker image from DockerHub



You can just build Docker image from the provided Dockerfile and run Docker container locally.

    cd jenkins-image-builder
    docker build -t michael/jenkins .
    docker run -d --name jenkins-server -p 80:8080 michael/jenkins
    
    docker will not work in container unless run with
    
    docker run -d --name jenkins-server -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 jenkins-pipeline:0.1
    
    https://stackoverflow.com/questions/38105308/jenkins-cant-connect-to-docker-daemon
    ----------------------------------------------------------------------------------
    

    docker tag  michael/jenkins ugbechie/jenkins-server:0.1
    docker push ugbechie/jenkins-server:0.1

    Terrafrom will then

    docker pull ugbechie/jenkins-server
    docker run -d --name jenkins-server -p 80:8080 -v /var/run/docker.sock:/var/run/docker.sock -v $JENKINS_HOME:/var/jenkins_home  ugbechie/jenkins-server:0.1
    
    
```

```
### Build Docker image from AWS ECR

Goto AWS ECR
    Create repository
            this example i used : pipeline/jenkins-server
            
Creates repository
    https://console.aws.amazon.com/ecr/repositories/pipeline/jenkins-server/?region=us-east-1
    

Make sure you run the start_aws_profile.sh as instructed in main README to setup ~/.aws/config and credentials

The container repo address:

https://console.aws.amazon.com/ecr/repositories/pipeline/jenkins-server/?region=us-east-1



1. Retrieve an authentication token and authenticate your Docker client to your registry.
   Use the AWS CLI:

   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 904806826062.dkr.ecr.us-east-1.amazonaws.com

   Note: If you receive an error using the AWS CLI, make sure that you have the latest version of the AWS CLI and Docker installed.
   Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions here . You can skip this step if your image is already built:

2. Build the container with tage
   
   docker build -t pipeline/jenkins-server .


3.  After the build completes, tag your image so you can push the image to this repository:

    docker tag pipeline/jenkins-server:latest 904806826062.dkr.ecr.us-east-1.amazonaws.com/pipeline/jenkins-server:latest

3.1 Or covert from another tagged image

    docker tag ugbechie/jenkins-server:latest 904806826062.dkr.ecr.us-east-1.amazonaws.com/pipeline/jenkins-server:latest


4.  Run the following command to push this image to your newly created AWS repository:
    
    docker push 904806826062.dkr.ecr.us-east-1.amazonaws.com/pipeline/jenkins-server:latest

    

5.  Pull
    ---

    docker pull 904806826062.dkr.ecr.us-east-1.amazonaws.com/pipeline/jenkins-server:latest
    
6.  Run

    docker run -d --name jenkins-server -p 80:8080 -v $JENKINS_HOME:/var/jenkins_home 904806826062.dkr.ecr.us-east-1.amazonaws.com/pipeline/jenkins-server:latest

```

