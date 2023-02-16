locals {
  res = join("", [var.resource_type, var.user, var.location,var.environment])
}