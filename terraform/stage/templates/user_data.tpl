#!/bin/bash

JENKINS_HOME=/opt/jenkins_home

# Create and set correct permissions for Jenkins mount directory
sudo mkdir -p $JENKINS_HOME
sudo chmod -R 777 $JENKINS_HOME

# Retrieving from Docker
docker pull ugbechie/jenkins-server

# Start Jenkins
docker run -d --name jenkins-server -p 80:8080 -v $JENKINS_HOME:/var/jenkins_home  ugbechie/jenkins-server

#docker run -id --name jenkins -p 80:8080 -p 50000:50000 -v $JENKINS_HOME:/var/jenkins_home jenkins/jenkins:lts


