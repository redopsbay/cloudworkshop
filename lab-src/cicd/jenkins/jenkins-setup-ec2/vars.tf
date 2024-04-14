/*
 * Terraform Variables
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */


variable "vpc_id" {
  type        = string
  description = "AWS VPC id for security group association"
}

variable "private_key" {
  type        = string
  description = "Location of private key file for ansible provisioning"
  default     = "jenkins.pem"
}

variable "vpc_jenkins_slave_subnet_id" {
  type        = string
  description = "Specifies jenkins slave vpc subnet id"
}

variable "vpc_jenkins_server_subnet_id" {
  type        = string
  description = "Specifies jenkins server vpc subnet id"
}
