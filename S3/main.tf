resource "aws_s3_bucket" "my_bucket" {
  bucket = "vinnu-terraform-bucket-demo"
  tags = {
    Name        = "Terraform-S3"
    Environment = "Dev"
  }
}

