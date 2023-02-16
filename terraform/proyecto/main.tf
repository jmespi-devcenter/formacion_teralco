# module "naming"{
#     source          = "./modules/naming"
#     user            = var.project.user
#     resource_type   = var.project.resource_type.s3
#     location        = var.project.location
#     environment     = var.project.environment
# }


module "bucket"{
    source          = "./modules/bucket"
    project         = var.project
}

module "vpc"{
    source          = "./modules/networks"
    project         = var.project
}

module "subnet" {
    source          = "./modules/subnets"
    vpc_id          = module.vpc.vpc_id
    project         = var.project
}

module "networksinterface" {
    source          = "./modules/networks_interface"
    subnet_id       = module.subnet.subnet_id
    project         = var.project
}

module "ec2"{
    source          = "./modules/instances"
    project         = var.project
    ni_id           = module.networksinterface.network_interface_id
    ami             = var.project.ami
}