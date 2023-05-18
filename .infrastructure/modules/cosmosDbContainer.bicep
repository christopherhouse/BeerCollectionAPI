param cosmosDbContainerName string
param partitionKey string
param cosmosDbDatabaseName string

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' existing = {
  name: cosmosDbDatabaseName
}

resource cosmosDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: cosmosDbContainerName
  parent: cosmosDbDatabase
  properties: {
    resource: {
      id: cosmosDbContainerName
      partitionKey: {
        paths: [
          partitionKey
        ]
        kind: 'Hash'
      }
    }
  }
}

output id string = cosmosDbContainer.id
output name string = cosmosDbContainer.name
