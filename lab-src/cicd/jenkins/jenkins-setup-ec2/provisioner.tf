/*
 * Resource Type: Terraform Ansible provisioning
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */

resource "null_resource" "ansible" {
  triggers = {
    cluster_instance_ids = "${aws_instance.jenkins_server.id},${aws_instance.jenkins_slave.id}"
  }

  provisioner "local-exec" {
    command     = "sleep 150s && export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -i ${path.module}/inventory.ini ${path.module}/ansible-playbook/playbook.yaml -b -v"
    interpreter = ["/bin/bash -c "]
  }
  depends_on = [
    aws_instance.jenkins_server,
    aws_instance.jenkins_slave,
    aws_key_pair.jenkins, aws_security_group.jenkins_server,
    aws_security_group.jenkins_slave
  ]
}
