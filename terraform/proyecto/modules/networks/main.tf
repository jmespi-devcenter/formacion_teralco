resource "aws_vpc" "jmabellan" {

  cidr_block       = var.project.cird
  instance_tenancy = "default"
 
 
  tags = {
    Name        = module.naming.name
    Nombre      = module.naming.name
    Environment = "dev_jmabellan"
  }
}

module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource_type   = var.project.resource_type.vpc
    location        = var.project.location
    environment     = var.project.environment
}