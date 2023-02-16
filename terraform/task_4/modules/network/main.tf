resource "aws_vpc" "jmabellan" {

  cidr_block       = var.cidr
  instance_tenancy = "default"
 
 
  tags = {
    Name    = "jmabellan"
    Nombre  = "jmabellan"
    Environment = "dev_jmabellan"
  }
}