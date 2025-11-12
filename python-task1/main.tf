provider "aws" {
  region = var.region
}

resource "aws_instance" "mysql_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl enable docker
                systemctl start docker
              usermod -aG docker ec2-user

              # Run MySQL container with root password from Terraform variable
              docker run -itd \
                --name mysqlcont123 \
                -e MYSQL_ROOT_PASSWORD=root123 \
                -e MYSQL_DATABASE=mydb \
                -e MYSQL-user=myuser \
                -e MYSQL_PASSWORD=1234 \
                -p 3306:3306 mysql:8.0
              EOF

  tags = {
    Name = "vinnu-terraform"
  }
}
