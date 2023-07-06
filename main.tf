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

resource "aws_security_group_rule" "http_ingress" {
  security_group_id = aws_security_group.jenkins_security_group.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_ingress_ipv6" {
  security_group_id = aws_security_group.jenkins_security_group.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = aws_security_group.jenkins_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Creación de la instancia EC2 para Jenkins
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

##################################################################################


# Creación del security group TomCat
resource "aws_security_group" "devops_security_group" {
  name        = "DevOpsSecurityGroupLucio1"
  description = "Security group for Tomcat server"
}

resource "aws_security_group_rule" "devops_ssh_ingress" {
  security_group_id = aws_security_group.devops_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "devops_http_ingress" {
  security_group_id = aws_security_group.devops_security_group.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "devops_docker_ingress" {
  security_group_id = aws_security_group.devops_security_group.id
  type              = "ingress"
  from_port         = 8081
  to_port           = 9000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "devops_egress_all" {
  security_group_id = aws_security_group.devops_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


# Creación de la instancia EC2 para TomCat
resource "aws_instance" "tomcat_instance" {
  ami                    = "ami-090e0fc566929d98b" # ID de la AMI de Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "devops_project_lucio_key"
  vpc_security_group_ids = [aws_security_group.devops_security_group.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "TomcatServerLucio1"
  }

}


##################################################################################


# Creación de la instancia EC2 para Docker
resource "aws_instance" "docker_instance" {
  ami                    = "ami-090e0fc566929d98b" # ID de la AMI de Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "devops_project_lucio_key"
  vpc_security_group_ids = [aws_security_group.devops_security_group.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "DockerHostLucio1"
  }

}


##################################################################################


# Creación de la instancia EC2 para Ansible
resource "aws_instance" "ansible_instance" {
  ami                    = "ami-090e0fc566929d98b" # ID de la AMI de Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "devops_project_lucio_key"
  vpc_security_group_ids = [aws_security_group.devops_security_group.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "AnsibleHostLucio1"
  }

}


##################################################################################


# Creación de la instancia EC2 para bootstrap K8S
resource "aws_instance" "EKSBootstrap_instance" {
  ami                    = "ami-090e0fc566929d98b" # ID de la AMI de Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "devops_project_lucio_key"
  vpc_security_group_ids = [aws_security_group.devops_security_group.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "EKSBootstrapHostLucio1"
  }

}

# Creación del rol para la instancia EC2 para bootstrap K8S
resource "aws_iam_role" "eksctl_role_lucio1" {
  name = "eksctl_role_lucio1"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "eksctl_role_lucio1_full_access" {
  role       = aws_iam_role.eksctl_role_lucio1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "eksctl_role_lucio1_cf_full_access" {
  role       = aws_iam_role.eksctl_role_lucio1.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

resource "aws_iam_role_policy_attachment" "eksctl_role_lucio1_iam_full_access" {
  role       = aws_iam_role.eksctl_role_lucio1.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "eksctl_role_lucio1_admin_access" {
  role       = aws_iam_role.eksctl_role_lucio1.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.eksctl_role_lucio1.name
}

