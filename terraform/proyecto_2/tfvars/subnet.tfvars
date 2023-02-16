subnets = {
    subnet_01 = {
        cidr_block          = "10.2.2.0/24"
        availability_zone   = "eu-central-1a"
        resource            = "subnet"
        del                 = "-"
        vpc_name            = "vpc_01"
        public              = false
        tipo_subnet         = "priv"
    }
    subnet_02 = {
        cidr_block          = "10.2.3.0/24"
        availability_zone   = "eu-central-1a"
        resource            = "subnet"
        del                 = "-"
        vpc_name            = "vpc_01"
        public              = false
        tipo_subnet         = "priv"
    }
    subnet_03 = {
        cidr_block          = "10.2.4.0/24"
        availability_zone   = "eu-central-1b"
        resource            = "subnet"
        del                 = "-"
        vpc_name            = "vpc_01"
        public              = true
        tipo_subnet         = "pub"
    }

}