terraform {
   
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }

    vault = {
      source = "hashicorp/vault"
      version = "2.20.0"
    }
  }
}

provider "vault" {}

data "vault_azure_access_credentials" "creds" {
  backend = "azure"
  role    = "sub-contributor"
  validate_creds = true
  num_sequential_successes = 2
  num_seconds_between_tests = 20
  max_cred_validation_seconds = 1200 // 20 minutes
}

provider "azurerm" {
  features {}
  client_id = data.vault_azure_access_credentials.creds.client_id
  client_secret = data.vault_azure_access_credentials.creds.client_secret
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

