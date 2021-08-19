# terraform-vault-azure-demo

This code example integrates with HashiCorp Vault to generate an ephemeral Azure AD Service Principal for a Terraform run. This example deploys a simple resource group and a vnet in Azure.

## Reference Links

[Using HashiCorp Vault to generate ephemeral Azure AD Service Principles](https://mattinthecloud.medium.com/using-hashicorp-vault-to-generate-ephemeral-azure-ad-service-principles-8354955b6b29)
[Azure Secrets Engine](https://learn.hashicorp.com/tutorials/vault/azure-secrets)
[Active Directory Secrets Engine](https://www.vaultproject.io/docs/secrets/ad)

## Required Environment Variables

Environment Variable | Description | Required
---|---|---
ARM_TENANT_ID | Defines the Azure Tenant ID for the deployment | Yes
ARM_SUBSCRIPTION_ID | Defines the Azure Subscription ID for the deployment | Yes
ARM_CLIENT_ID | Defines the Azure AD Client ID. When using Vault for authentication this value should not be used | No
ARM_CLIENT_SECRET | Defines the Azure AD Password. When using Vault for authentication this value should not be used | No
VAULT_ADDR | Defines the URL of the Vault Server, e.g. https://127.0.0.1:8200 | Yes
VAULT_TOKEN | Defines the Vault authentication token for the role assignment in HashiCorp Vault | Yes


## HashiCorp Vault Role Configuration

Vault Role to grant Contributor to the ephemeral Azure AD to an Azure subscription - replace subscription_guid with value

```hcl 
vault write azure/roles/sub-contributor ttl=60m azure_roles=-<<EOF
    [
      {
        "role_name": "Contributor",
        "scope": "/subscriptions/subscription_guid"
      }
    ]
EOF
```

Vault Role to grant access to the newly created root management group so that future runs of Terraform can perform actions on management group -- replace ParentManagementGroup with the parent management group

```hcl
vault write azure/roles/lz-permission ttl=60m azure_roles=-<<EOF
    [
      {
        "role_name": "User Access Administrator",
        "scope": "/providers/Microsoft.Management/managementGroups/ParentManagementGroup"
      },
      {
        "role_name": "Management Group Contributor",
        "scope": "/providers/Microsoft.Management/managementGroups/ParentManagementGroup "
      }
    ]
EOF

```
