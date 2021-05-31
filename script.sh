#!/bin/bash 
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel
sudo yum update -y
sudo yum install ansible -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
docker run -p 8080:80 -d --name nginx1 nginx