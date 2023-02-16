variable "resource" {
    type = string
}

variable "user" {
    type = string
}

variable "environment" {
    type = string
    validation {
        condition = length(var.environment) == 3
        error_message = "La longitud del environment ha de ser 3"
    }
}

variable "location" {
    type = string
}

variable "del" {
    type = string
    default = "-"
}

variable "indice" {
    type = number
 }

 variable "tipo_subnet"{
    type    = string
    default = ""
 }




