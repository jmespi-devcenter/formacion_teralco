resource "aws_subnet" "my_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet.cidr_block
  availability_zone = var.subnet.availability_zone
  map_public_ip_on_launch = var.subnet.public

  tags = {
    Name = module.naming.name
  }
}

module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource        = var.subnet.resource
    location        = var.project.location
    environment     = var.project.environment
    indice          = var.indice
    tipo_subnet     = var.tipo_subnet
}

