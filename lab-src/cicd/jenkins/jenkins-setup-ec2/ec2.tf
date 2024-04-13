/*
 * Resource Type: EC2 Instance
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.jenkins.key_name
  security_groups             = [aws_security_group.jenkins_server.id]
  tags                        = merge({ Name = "Jenkins Server" }, local.resource_tags)

  root_block_device {
    delete_on_termination = true
    tags                  = merge({ Name = "Jenkins Server" }, local.resource_tags)
    volume_size           = "50"
    volume_type           = "gp3"
  }

  depends_on = [aws_key_pair.jenkins, aws_security_group.jenkins_server]
}

resource "aws_instance" "jenkins_slave" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.jenkins.key_name
  security_groups             = [aws_security_group.jenkins_slave.id]

  tags = merge({ Name = "Jenkins Slave" }, local.resource_tags)

  root_block_device {
    delete_on_termination = true
    tags                  = merge({ Name = "Jenkins Slave" }, local.resource_tags)
    volume_size           = "50"
    volume_type           = "gp3"
  }

  depends_on = [aws_key_pair.jenkins, aws_security_group.jenkins_slave]

}
