variable "resource_type" {
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



