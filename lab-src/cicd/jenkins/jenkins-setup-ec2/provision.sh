#!/bin/bash

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

echo -e "\n\n[INFO] Running terraform init,fmt,validate...."

terraform init && terraform fmt && terraform validate

echo -e "\n\n[INFO] Running terraform plan -out=plan.out ..."
terraform plan \
  -var=vpc_id="$vpc_id" \
  -var=vpc_jenkins_slave_subnet_id="$slave_subnet_id" \
  -var=vpc_jenkins_server_subnet_id="$server_subnet_id" \
  -out=plan.out \
  -state=resource.tfstate

echo -e "\n\n[WARNING] Applying terraform resources ..."
terraform apply \
  -state=resource.tfstate \
  plan.out
