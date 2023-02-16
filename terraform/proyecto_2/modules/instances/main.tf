resource "aws_instance" "jmabellan" {
  ami           = var.instance.ami
  instance_type = var.instance.type

  tags = {
    Name = module.naming.name
  }

  network_interface {
    network_interface_id = var.ni_id
    device_index         = 0
  }
}

module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource        = var.instance.resource
    location        = var.project.location
    environment     = var.project.environment
    indice          = var.indice
    del             = var.instance.del
}

