resource "aws_instance" "my_ec2" {
  ami           = "ami-0305d3d91b9f22e84"
  instance_type = "t3.micro"
  key_name      = "vinnu-ssh"

  tags = {
    Name = "Terraform-py"
  }
}



provider "aws" {
  region = var.region
}
