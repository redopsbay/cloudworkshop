/*
 * Resource Type: Security Group
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */


resource "aws_security_group" "jenkins_server" {
  name   = "jenkins-server-devops-workshop"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow https"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  tags = merge({ Name = "jenkins-server-devops-workshop" }, local.resource_tags)

}


resource "aws_security_group" "jenkins_slave" {
  name   = "jenkins-slave-devops-workshop"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = -1
    from_port   = 0
    to_port     = 0
  }

  tags = merge({ Name = "jenkins-slave-devops-workshop" }, local.resource_tags)
}
