/*
 * TF Local Variables
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */


locals {
  vpc_id           = try(var.vpc_id, "")
  slave_subnet_id  = try(var.vpc_jenkins_slave_subnet_id, "")
  server_subnet_id = try(var.vpc_jenkins_server_subnet_id, "")
  resource_tags = {
    Project      = "DevOps WorkShop Jenkins CICD"
    Provisioner  = "Terraform"
    ConfiguredBy = "Ansible"
  }
  ansible_inventory_file = "${path.module}/inventory.ini"
}
