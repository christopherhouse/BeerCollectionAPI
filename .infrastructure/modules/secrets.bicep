param keyVaultName string
param cosmosDbName string
param containerRegistryName string
param apimAppInsightsName string
param containerAppsAppInsightsName string

resource keyVault 'Microsoft.KeyVault/vaults@2018-02-14' existing = {
  name: keyVaultName
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: containerRegistryName
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15'existing = {
  name: cosmosDbName
}

resource apimAppInsights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: apimAppInsightsName
}

resource containerAppsAppInsights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: containerAppsAppInsightsName
}

resource cosmosDbConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'COSMOS-DB-CONNECTION-STRING'
  parent: keyVault
  properties: {
    value: cosmosDb.listConnectionStrings().connectionStrings[0].connectionString
  }
}

resource acr 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'ACR-PASSWORD'
  parent: keyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
  }
}

resource apimAppInsightsKey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'APIM-APPINSIGHTS-INSTRUMENTATION-KEY'
  parent: keyVault
  properties: {
    value: apimAppInsights.properties.InstrumentationKey
  }
}

resource acaAppInsightsConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'ACA-APPINSIGHTS-CONNECTION-STRING'
  parent: keyVault
  properties: {
    value: containerAppsAppInsights.properties.InstrumentationKey
  }
}

output cosmosDbSecretUri string = cosmosDbConnectionString.properties.secretUri
output acrAdminCredsSecretUri string = acr.properties.secretUri
output acaAppInsightsConnectionStringSecretUri string = acaAppInsightsConnectionString.properties.secretUri
output apimAppInsightsKeySecretUri string = apimAppInsightsKey.properties.secretUri
