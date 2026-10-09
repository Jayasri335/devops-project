
# Security Group
resource "aws_security_group" "allow_tls" {
  name        = "Learn-SG"
  description = "Allow SSH HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.demo.id

  tags = {
    Name = "Learn-SG"
  }
}

# Allow SSH
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allow HTTPS
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Allow HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 Instance 1
resource "aws_instance" "testec2_1" {
  ami           = "ami-0d27e0fb3bac4d724"
  subnet_id     = aws_subnet.pub-sub.id
  instance_type = "t3.micro"
  key_name      = "webserver"

  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y docker
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
  EOF

  tags = {
    Name = "docker-server-1"
    team = "sjce-devops"
  }
}

# EC2 Instance 2
resource "aws_instance" "testec2_2" {
  ami           = "ami-0d27e0fb3bac4d724"
  subnet_id     = aws_subnet.pub-sub-2.id
  instance_type = "t3.micro"
  key_name      = "webserver"

  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y docker
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
  EOF

  tags = {
    Name = "docker-server-2"
    team = "sjce-devops"
  }
}

# EC2 Instance 1 Public IP
output "ec2_1_public_ip" {
  value = aws_instance.testec2_1.public_ip
}

# EC2 Instance 2 Public IP
output "ec2_2_public_ip" {
  value = aws_instance.testec2_2.public_ip
}



