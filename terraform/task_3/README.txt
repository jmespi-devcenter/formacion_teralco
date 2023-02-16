Para ejecutar este ejemplo hace falta referenciar el fichero .tfvars a la hora de hacer el plan o el apply

terraform plan -var-file="users.tfvars"
terraform apply -var-file="users.tfvars"