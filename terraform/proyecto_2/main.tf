# module "naming"{
#     source          = "./modules/naming"
#     user            = var.project.user
#     resource_type   = var.project.resource_type.s3
#     location        = var.project.location
#     environment     = var.project.environment
# }


module "bucket"{
    source          = "./modules/bucket"
    for_each        = var.buckets
    bucket          = each.value
    project         = var.project
    indice          = format("%02d", index(keys(var.buckets),each.key))
}

module "vpc"{
    source          = "./modules/networks"
    for_each        = var.vpcs
    vpc             = each.value 
    project         = var.project
    indice          = format("%02d", index(keys(var.vpcs),each.key))
    vpc_name        = each.key

}

module "subnet" {
    source          = "./modules/subnets"
    for_each        = var.subnets
    subnet          = each.value
    vpc_id          = module.vpc[each.value.vpc_name].vpc_id
    project         = var.project
    indice          = format("%02d", index(keys(var.subnets),each.key))

    tipo_subnet     =  each.value.public ? "pub" : "priv"
    # ? tipo_subnet = "priv":tipo_subnet = "pub"
}


module "network_interfaces" {
    source              = "./modules/networks_interface"
    for_each            = var.network_interfaces
    network_interface   = each.value
    subnet_id           = module.subnet[each.value.subnet_name].subnet_id
    project             = var.project
    indice              = format("%02d", index(keys(var.network_interfaces),each.key))
}

module "ec2"{
    source          = "./modules/instances"
    for_each        = var.instances
    instance        = each.value
    ni_id           = module.network_interfaces[each.value.ni_name].network_interface_id
    project         = var.project
    indice          = format("%02d", index(keys(var.instances),each.key))
}