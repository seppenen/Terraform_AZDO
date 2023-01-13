# Terraform_AZDO
 
This is a Terraform module to create an Azure DevOps project and a service connection to an Azure subscription. It also creates a service connection to external Azure DevOps repositories for configuring a multi-stage pipeline and creates a service connection to an Azure Container Registry for deploying containerized applications.

Run this command to create a new Terraform project in Azure DevOps
 
```bash 
terraform apply -auto-approve -var ado_personal_access_token=<AZDO PERSONAL TOKEN> -var ado_repo_password=<ADO REPO PASSWORD>   