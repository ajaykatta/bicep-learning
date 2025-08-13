param location string = 'eastus' // resourceGroup().location
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
// param appServicePlanName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'

// var appServicePlanName = 'toy-product-launch-plan'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = environmentType == 'prod' ? 'Premium_GRS' : 'Standard_LRS'
var appServicePlanSku = environmentType == 'prod' ? 'P1v2' : 'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'toy-product-launch-plan'
  location: location
  sku: {
    name: appServicePlanSku
  }
}

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
