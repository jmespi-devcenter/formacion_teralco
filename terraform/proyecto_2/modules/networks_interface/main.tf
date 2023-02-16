

resource "aws_network_interface" "jmabellan" {
  subnet_id   = var.subnet_id
  private_ips = var.network_interface.private_ips

  tags = {
    Name = module.naming.name
  }
}

module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource        = var.network_interface.resource
    location        = var.project.location
    environment     = var.project.environment
    indice          = var.indice
    del             = var.network_interface.del 
}


