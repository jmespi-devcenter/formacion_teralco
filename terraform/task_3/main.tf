
module "s3" {
  source = "./s3"
}


module "users" {
  source = "./usuarios"
  nombres = var.nombres
}

