region                  = "ap-south-1"
ami                     = "ami-0ad79b094e106ba8f"
instance_type           = "t3.micro"
key_name                = "vinnu-ssh"
subnet_id               = "subnet-00823b0858ae53bfc"
vpc_security_group_ids  = ["sg-08325113f9d49ea07"]

# Sensitive secret value
mysql_root_password     = "root123"
