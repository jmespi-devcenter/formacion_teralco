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

resource "aws_iam_user" "usuario" {
  count = 9
  name  = "usuario_${count.index}"

}


resource "aws_iam_user" "usuario_marvel" {
  
  for_each = var.nombres

  name  = each.value
}

