terraform {
  required_providers {
    azurerm = {
    }

    tls = {}

    local = {}
  }
}

provider "azurerm" {
  subscription_id = "168b5162-e625-42f1-994a-dfcfff0433bb"
  features {}
}