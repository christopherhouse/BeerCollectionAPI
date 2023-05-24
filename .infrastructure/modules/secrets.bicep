param keyVaultName string
param cosmosDbName string

resource keyVault 'Microsoft.KeyVault/vaults@2018-02-14' existing = {
  name: keyVaultName
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

output cosmosDbSecretUri string = cosmosDbConnectionString.properties.secretUri
