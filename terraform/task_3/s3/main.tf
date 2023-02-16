resource "aws_s3_bucket" "jmabellan" {
  bucket = "jmabellan-dev"

  tags = {
    Name        = "jmabellan"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "jmabellan" {
  bucket = aws_s3_bucket.jmabellan.id
  acl    = "private"
}