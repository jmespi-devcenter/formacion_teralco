project = {
    name            = "jmabellan"
    environment     = "pro"
    location        = "aws"
    user            = "jmabellan"
        resource_type   = {
            ec2                         = "ec2resource"
            subnet_numbres_of_istances  = 2
            ni                          = "networkInterface"
            ni_numbres_of_istances      = 2
        }
    
}
