resource "aws_subnet" "my_subnet" {
  vpc_id            =  var.vpc_id
  cidr_block        = "10.2.2.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = module.naming.name
  }
}

module "naming"{
    source          = "../naming"
    user            = var.project.user
    resource_type   = var.project.resource_type.subnet
    location        = var.project.location
    environment     = var.project.environment
}

