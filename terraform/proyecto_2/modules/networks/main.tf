resource "aws_vpc" "jmabellan" {

  cidr_block       = var.vpc.cird
  instance_tenancy = var.vpc.tenancy
 
 
  tags = {
    Name        = module.naming.name
    Nombre      = module.naming.name
    Environment = var.project.environment
  }
}

module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource        = var.vpc.resource
    location        = var.project.location
    environment     = var.project.environment
    indice          = var.indice
    del             = var.vpc.del
}