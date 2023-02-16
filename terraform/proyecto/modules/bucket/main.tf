resource "aws_s3_bucket" "jmabellan" {
  bucket = module.naming.name

  tags = {
    Name        = "jmabellan"
    Environment = "dev_jmabellan"
  }
}



module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource_type   = var.project.resource_type.s3
    location        = var.project.location
    environment     = var.project.environment
}