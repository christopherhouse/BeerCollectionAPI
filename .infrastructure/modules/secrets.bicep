param keyVaultName string
param cosmosDbName string
param containerRegistryName string

resource keyVault 'Microsoft.KeyVault/vaults@2018-02-14' existing = {
  name: keyVaultName
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: containerRegistryName
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15'existing = {
  name: cosmosDbName
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

output cosmosDbSecretUri string = cosmosDbConnectionString.properties.secretUri
output acrAdminCredsSecretUri string = acr.properties.secretUri
