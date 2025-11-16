1. Create IAM User
=> IAM user -> create user -> user name -> next -> Attach policy directly -> AdministratorFullAccess -> next -> create  -> Users -> select your user name -> Access key 1
Create access key -> download CSV file
2. Connect user to vscode through access and secert key
=> vscode terminal -> aws configure -> ask Access and secret keys, region and Format(json)
3. Create one t3.micro instance in ap-south-1 region and in instance install docker and run mysql container

**Main.tf**
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

**Variable.tf**

variable "region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "Amazon Machine Image ID"
  type        = string
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Existing subnet ID"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}


**Security.tf**
resource "aws_security_group" "mysql_sg" {
  name        = "allow_ssh_mysql"
  description = "Allow SSH and MySQL"
  

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_mysql"
  }
}


**Terraform.tfvars**
region                  = "ap-south-1"
ami                     = "ami-0ad79b094e106ba8f"
instance_type           = "t3.micro"
key_name                = "vinnu-ssh"
subnet_id               = "subnet-00823b0858ae53bfc"
vpc_security_group_ids  = ["sg-08325113f9d49ea07"]

# Sensitive secret value
mysql_root_password     = "root123"


**Output.tf**
# output.tf

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.mysql_instance.public_ip
}

output "subnet_id" {
  description = "Subnet ID used for EC2"
  value       = var.subnet_id
}

output "security_group_ids" {
  description = "Security Group IDs used for EC2"
  value       = var.vpc_security_group_ids
}

output "region" {
  description = "AWS region in use"
  value       = var.region
}



variable "mysql_root_password" {
  description = "Root password for MySQL container"
  type        = string
  sensitive   = true
}


=> Run the main.tf file -> terraform init -> terraform validate -> terraform plan -> terraform apply

4. Check instance is running in EC2 service -> add port no: 22 and 3306 in security groups

5. Write in Python dummy data and excute in SQL Container


**Python_mysql.py**
import pymysql
import time

# Wait for MySQL to start properly
time.sleep(20)

connection = pymysql.connect(
    host="13.233.224.23",
    user="myuser",
    password="1234",
    port=3306
)

cursor = connection.cursor()

# Create database
cursor.execute("CREATE DATABASE IF NOT EXISTS company")
cursor.execute("USE company")

# Create table
cursor.execute("""
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    role VARCHAR(50),
    salary INT
)
""")

# Insert dummy data 
data = [
     ("vineetha", "IT", 65000),
    ("eswari", "HR", 150000),
    ("siva", "Finance", 72000),
     ("vijay", "IT", 80000),
    ("abhiram", "HR", 90000),
    ("moses", "Finance", 172000)
]

cursor.executemany("INSERT INTO employees (name, role, salary) VALUES (%s, %s, %s)", data)
connection.commit()

# Display all data
cursor.execute("SELECT * FROM employees")
rows = cursor.fetchall()

print("\nEmployee Table Data:\n----------------------")
for row in rows:
    print(row)

connection.close()

=>aws sts get-caller-identity(Check AWS CLI credentials) -> aws configure(Configure credentials) -> AWS IAM → Users → Security credentials → Create access key -> Make sure it belongs to a user with EC2 permissions.

=> Verify credentials file(C:\Users\<your_username>\.aws\credentials)
=> sudo yum install python3-pip -y (Install pip for Python 3) -> pip3 --version (Verify pip installation) -> sudo pip3 install pymysql (sudo pip3 install mysql-connector-python) -> python3 -m pip show mysql-connector-python (verify) 
=> scp -i "C:\Users\vinee\.ssh\vinnu-ssh.pem" D:\aws\python\db.py ec2-user@ec2-3-109-58-106.ap-south-1.compute.amazonaws.com:/home/ec2-user/ (Copy the local file to EC2) -> mv /home/ec2-user/db.py /root/ -> ls /root/ (Verify inside EC2) 
=> docker exec -it mysqlcont123 bash (MySQL inside the container) -> mysql -u root -p (ask password) -> use db_name -> show tables -> select * from table name 
(or)
=> python3 python-mysql.py (Then back on your EC2:)
=> You should see the output:
Employees Data:
(1, 'vineetha', 'IT', 65000.0)
(2, 'eswari', 'HR', 150000.0)
(3, 'siva', 'Finance', 72000.0)
...





