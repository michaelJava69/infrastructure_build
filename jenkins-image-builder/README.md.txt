# Automated Jenkins setup with Docker and Terraform

Source code in this repository is used for set of Jenkins tutorials on [Popularowl](https://www.popularowl.com).

* [Installing, configuring and running JenkinsCI server](https://www.popularowl.com/blog/installing-configuring-jenkinsci-nginx)
* [Automating Jenkins install and configuration with Docker and Terraform](https://www.popularowl.com/jenkins/automating-jenkins-install-docker-terraform)
* [Jenkins plugins and plugin management](https://www.popularowl.com/jenkins/jenkins-plugins-and-plugin-management)

## How to use

 

### Build Docker image

You can just build Docker image from the provided Dockerfile and run Docker container locally.

    cd files
    docker build -t popularowl/jenkins .
    docker run -d --name jenkins-server -p 8080:8080 popularowl/jenkins

