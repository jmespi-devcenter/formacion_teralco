

resource "aws_network_interface" "jmabellan" {
  subnet_id   = var.subnet_id
  private_ips = ["10.2.2.240"]

  tags = {
    Name = module.naming.name
  }
}

module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource_type   = var.project.resource_type.ni
    location        = var.project.location
    environment     = var.project.environment
}


