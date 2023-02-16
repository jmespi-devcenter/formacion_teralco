locals {
  res = join(var.del, compact([var.resource, var.user, var.location,var.environment, var.indice, var.tipo_subnet]))
}