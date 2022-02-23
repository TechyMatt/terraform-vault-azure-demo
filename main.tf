terraform {
   
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }

    vault = {
      source = "hashicorp/vault"
      version = "3.3.0"
    }
  }
}

provider "vault" {
  
}

data "vault_azure_access_credentials" "creds" {
  backend = "azure"
  role    = "edu-app"
  validate_creds = true
  num_sequential_successes = 20
  num_seconds_between_tests = 30
  max_cred_validation_seconds = 1200 // 20 minutes
}

provider "azurerm" {
  features {}
  client_id = data.vault_azure_access_credentials.creds.client_id
  client_secret = data.vault_azure_access_credentials.creds.client_secret
  subscription_id = "171a7c9d-0a7f-468a-b006-7075e2f25f74" 
  tenant_id = "9bdc7fd9-30ec-41bd-8238-7e5f2d6bbea4"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "Vault-Demo-Resources"
  location = "East US 2"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

