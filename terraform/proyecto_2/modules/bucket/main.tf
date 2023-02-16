resource "aws_s3_bucket" "jmabellan" {
  bucket = module.naming.name

  tags = {
    Name        = module.naming.name
    Environment = var.project.environment
  }
}





module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource        = var.bucket.resource
    location        = var.project.location
    environment     = var.project.environment
    del             = var.bucket.del
    indice          = var.indice
}