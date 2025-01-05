#!/bin/bash

sudo yum update && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo curl -sl "https://github.com/docker/compose/releases/download/v2.32.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose