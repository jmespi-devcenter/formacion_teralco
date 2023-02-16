module "test" {
    source = "./modules"
    nombre = var.nombre
    prefijo = var.prefijo
    sufijo  = var.sufijo
    resultado = join("-", [var.prefijo, var.nombre, var.sufijo])
}

