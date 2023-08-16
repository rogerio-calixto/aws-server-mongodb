# aws-server-mongodb

# Descrição
Projeto para criacao de servidor MongoDB

## Inicializando / atualizando modulos
terraform init

## Comandos TF
terraform plan -out="tfplan.out"
terraform apply "tfplan.out"
terraform destroy -auto-approve
terraform output -json

### atualizacao de modulos
terraform get -update