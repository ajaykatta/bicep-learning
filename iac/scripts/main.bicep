@description('The name of the environment. This must be dev, qa, or prod.')
@allowed([
  'dev'
  'qa'
  'prod'
])
param environmentName string = 'dev'

@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The number of instances for the App Service Plan.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The SKU of the App Service Plan.')
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
}

@description('The azure region where the resources will be deployed.')
param location string = 'eastus'

param appServicePlanName string = '${environmentName}-${solutionName}-plan'
param appServiceAppName string = '${environmentName}-${solutionName}-app'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
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
