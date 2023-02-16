project = {
    name            = "jmabellan"
    environment     = "pro"
    location        = "aws"
    user            = "jmabellan"
        resource_type   = {
            s3      = "s3resource"
            vpc     = "vpcresource"
            ec2     = "ec2resource"
            subnet  = "subnet"
            ni      = "networkInterface"
        }
    cird = "10.2.0.0/16"
    ami = "ami-06c39ed6b42908a36"
}