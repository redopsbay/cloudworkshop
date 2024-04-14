/*
 * Resource Type: AWS EC2 Key Pair
 * Author: Alfred Valderrama
 * Github: https://github.com/redopsbay
 * Website: https://redopsbay.dev
 */

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins_key"
  public_key = tls_private_key.tls_key.public_key_openssh
}
