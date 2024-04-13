/*
 * Resource Type: Ansible inventory file
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.tls_key.private_key_pem
  filename        = format("%s/%s", abspath(path.module), "${var.private_key}")
  file_permission = "0600"
  depends_on      = [tls_private_key.tls_key]
}


data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")
  vars = {
    jenkins_server_ip = "${aws_instance.jenkins_server.public_ip}"
    jenkins_slave_ip  = "${aws_instance.jenkins_slave.public_ip}"
    jenkins_pem       = "${path.module}/${var.private_key}"
  }
}
