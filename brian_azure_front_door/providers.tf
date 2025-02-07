# Required versions and sources of the providers used in the configuration.
terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
# Include Subscripiton ID here to ensure it lands in the correct subscription/ tenant
provider "azurerm" {
  subscription_id = "168b5162-e625-42f1-994a-dfcfff0433bb"
  features {}
}