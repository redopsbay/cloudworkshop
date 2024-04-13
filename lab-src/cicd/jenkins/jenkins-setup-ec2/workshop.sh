#!/bin/bash

function setup_cli()
{
  ### Setup Python3 pip

  echo "[info] install the following packages: python3-pip zip unzip "
  sudo yum install python3-pip zip unzip -y

  ### Install ansible

  echo "[info] install ansible"
  sudo pip3 install ansible

  ### Download and Install Terraform version: 1.8.0

  echo "[info] download and install terraform version 1.8.0"
  curl -Lo terraform.zip https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_linux_amd64.zip
  unzip terraform.zip && sudo install terraform /usr/local/bin/

  ### setup ansible default config

  cat << _EOF > ~/.ansible.cfg
  [default]
  host_key_checking = False
  _EOF

  ### Disable host key checking on ssh

  mkdir ~/.ssh
  cat <<_EOF > ~/.ssh/config
  Host *
      StrictHostKeyChecking no
  _EOF

}

function delete_resource()
{
  terraform destroy \
    -var-file=./vars.tfvars \
    -state=resource.tfstate
}

function provision()
{
  echo '[INFO] Retrieving the default VPC ID on ap-southeast-1'
  aws ec2 describe-vpcs --output table --query 'Vpcs[*].VpcId' --region ap-southeast-1

  read -p 'Enter Target VPC ID: ' vpc_id

  echo "[INFO] Displaying Available subnets on vpc: $vpc_id"
  aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" --query 'Subnets[*].[SubnetId,AvailabilityZone]' --output table

  echo -e "\n\nNote: You can use the same subnet id for jenkins server and slave!\n\n"
  read -p 'Enter Subnet ID for Jenkins Server: ' server_subnet_id
  read -p 'Enter Subnet ID for Jenkins Slave: ' slave_subnet_id

  echo -e "\n\n[INFO] Displaying user inputs\n\n"
  echo "VPC ID: $vpc_id"
  echo "Server Subnet ID: $server_subnet_id"
  echo -e "Slave Subnet ID: $slave_subnet_id\n\n"

  echo "[INFO] Creating vars.tfvars file ..."

  cat <<_EOF > vars.tfvars
  vpc_id = "$vpc_id"
  vpc_jenkins_slave_subnet_id = "$server_subnet_id"
  vpc_jenkins_server_subnet_id = "$slave_subnet_id"
  _EOF

  echo -e "\n\n[INFO] Running terraform init,fmt,validate...."

  terraform init && terraform fmt && terraform validate

  echo -e "\n\n[INFO] Running terraform plan -out=plan.out ..."
  terraform plan \
    -var-file=./vars.tfvars \
    -out=plan.out \
    -state=resource.tfstate

  echo -e "\n\n[WARNING] Applying terraform resources ..."
  terraform apply \
    -state=resource.tfstate \
    plan.out

}

echo -e "\n============= Choose target action =============\n"
echo -e "1) Setup CLI Binaries\n"
echo -e "2) Provision Jenkins\n"
echo -e "3) Cleanup Terraform Resources\n"
read -p 'Choose action: ' action

case $action in
  1) setup_cli;;
  2) provision;;
  3) delete_resource;;
esac
