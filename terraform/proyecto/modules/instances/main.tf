resource "aws_instance" "jmabellan" {
  ami           = var.ami
  instance_type = "t3.micro"

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
    resource_type   = var.project.resource_type.ec2
    location        = var.project.location
    environment     = var.project.environment
}


# module "vpc"{
#     source          = "../networks"
# }