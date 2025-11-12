resource "aws_instance" "my_ec2" {
  ami           = "ami-001a2e58bb6d4be31"
  instance_type = "t3.micro"
  key_name      = "project1"

  tags = {
    Name = "Terraform-EC2"
  }
}

resource "null_resource" "start_instance" {
  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${aws_instance.my_ec2.id}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
