module "network" {
    source  = "./modules/network"
    cidr    = var.project.cidr
}

module "device" {
    source = "./modules/devices"
    bucket = var.project.bucket
}

module "instances" {
    count = var.project.ami_instances
    source  = "./modules/instances"
    ec2Name    = "jmabellan_${count.index}"
}