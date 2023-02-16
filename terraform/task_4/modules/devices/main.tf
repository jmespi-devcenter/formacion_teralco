resource "aws_s3_bucket" "jmabellan" {
  bucket = var.bucket

  tags = {
    Name        = "jmabellan"
    Environment = "dev_jmabellan"
  }
}