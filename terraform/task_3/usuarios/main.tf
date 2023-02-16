resource "aws_iam_user" "usuario" {
  count = 9
  name  = "usuario_${count.index}"

}


resource "aws_iam_user" "usuario_marvel" {
  
  for_each = var.nombres

  name  = each.value
}