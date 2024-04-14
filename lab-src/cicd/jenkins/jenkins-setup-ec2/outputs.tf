/*
 * Resource Type: TF Output
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */

output "slave_arn" {
  value = aws_instance.jenkins_slave.arn
}

output "slave_id" {
  value = aws_instance.jenkins_slave.id
}

output "slave_state" {
  value = aws_instance.jenkins_slave.instance_state
}

output "slave_public_ip" {
  value = aws_instance.jenkins_slave.public_ip
}

output "slave_public_dns" {
  value = aws_instance.jenkins_slave.public_dns
}

output "slave_tags" {
  value = aws_instance.jenkins_slave.tags_all
}

output "server_arn" {
  value = aws_instance.jenkins_server.arn
}

output "server_id" {
  value = aws_instance.jenkins_server.id
}

output "server_state" {
  value = aws_instance.jenkins_server.instance_state
}

output "server_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "server_public_dns" {
  value = aws_instance.jenkins_server.public_dns
}

output "server_tags" {
  value = aws_instance.jenkins_server.tags_all
}

output "server_sg_arn" {
  value = aws_security_group.jenkins_server.arn
}

output "server_sg_id" {
  value = aws_security_group.jenkins_server.id
}

output "server_sg_tags" {
  value = aws_security_group.jenkins_server.tags_all
}

output "slave_sg_arn" {
  value = aws_security_group.jenkins_slave.arn
}

output "slave_sg_id" {
  value = aws_security_group.jenkins_slave.id
}

output "slave_sg_tags" {
  value = aws_security_group.jenkins_slave.tags_all
}
