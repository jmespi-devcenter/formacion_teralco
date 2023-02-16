resource "aws_s3_bucket" "jmabellan" {
  bucket = "test"

  tags = {
    Name        = var.nombre
    Sufijo      = var.sufijo
    Prefijo     = var.prefijo
    Resultado   = var.resultado
  }
}