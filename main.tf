# Definición del proveedor AWS
provider "aws" {
  region  = "us-east-1"
  profile = "237889007525_PowerUserAccess"
}

# Creación del security group
resource "aws_security_group" "jenkins_security_group" {
  name        = "JenkinsSecurityGroupLucio1"
  description = "Security group for Jenkins server"
}

resource "aws_security_group_rule" "ssh_ingress" {
  security_group_id = aws_security_group.jenkins_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

#resource "aws_security_group_rule" "http_ingress" {
#  security_group_id = aws_security_group.jenkins_security_group.id
#  type              = "ingress"
#  from_port         = 8080
#  to_port           = 8080
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]
#  ipv6_cidr_blocks  = ["::/0"]
#}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = aws_security_group.jenkins_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Creación de la instancia EC2
resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-090e0fc566929d98b" # ID de la AMI de Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "devops_project_lucio_key"
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]

  # instance_state = "stopped" # running stopped

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "JenkinsServerLucio1"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
  #    "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
  #    "yum install -y fontconfig java-11-openjdk",
  #    "sudo amazon-linux-extras install -y epel",
  #    "sudo amazon-linux-extras install -y java-openjdk11",
  #    "yum install -y jenkins",
  #    "service jenkins start"
  #  ]
  #}
  #connection {
  #  host = self.private_ip
  #}

}