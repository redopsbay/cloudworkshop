#!/bin/bash

### Setup Python3 pip

echo "[info] install the following packages: python3-pip zip unzip "
sudo yum install python3-pip zip unzip -y

### Install ansible==9.4.0

echo "[info] install ansible==9.4.0"
sudo pip3 install ansible==9.4.0

### Download and Install Terraform version: 1.8.0

echo "[info] download and install terraform version 1.8.0"
curl -Lo terraform.zip https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_linux_amd64.zip
unzip terraform.zip && sudo install terraform /usr/local/bin/

### setup ansible default config

cat << _EOF > ~/.ansible.cfg
[default]
host_key_checking = False
_EOF
