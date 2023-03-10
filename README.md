# Terraform_AZDO
 
This is a Terraform module to create an Azure DevOps project and a service connection to an Azure subscription. It also creates a service connection to external Azure DevOps repositories for configuring a multi-stage pipeline, creates a service connection to an Azure Container Registry for deploying containerized applications and deploys a sample application to an Azure Kubernetes Service cluster.

This application uses external repository for the pipeline configuration. The repository is private and requires access password to be configured in the pipeline.
## Installation

Terraform only supports authenticating using the az CLI (and this must be available on your PATH) - authenticating using the older azure CLI or PowerShell Cmdlets are not supported.

### Logging into the Azure CLI

Firstly, login to the Azure CLI using:
```bash 
az login
```
Once logged in - it's possible to list the Subscriptions associated with the account via:
```bash 
az account list
``` 
The output (similar to below) will display one or more Subscriptions - with the id field being the subscription_id field referenced above.
```json
[
  {
    "cloudName": "AzureCloud",
    "id": "00000000-0000-0000-0000-000000000000",
    "isDefault": true,
    "name": "PAYG Subscription",
    "state": "Enabled",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "user": {
      "name": "user@example.com",
      "type": "user"
    }
  }
]
```
Should you have more than one Subscription, you can specify the Subscription to use via the following command:
```bash 
az account set --subscription="SUBSCRIPTION_ID"
```

### Environment installation

You will need to provide ado_repo_password to access the external repository. Also, you need to provide the personal access token (PAT) for the Azure DevOps organization. You can create a PAT token by following the instructions [here](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page).

Install the backend using the following commands:
```bash 
terraform init
``` 

### Usage

Setup all resources using the following commands:
```bash 
terraform apply -auto-approve -var-file="env.tfvars"
```

Destroy all resources by running the following commands:
```bash
terraform apply -destroy -auto-approve -var-file="env.tfvars"
```