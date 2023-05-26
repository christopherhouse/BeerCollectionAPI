param cosmosDbContainerName string
param partitionKeyPath string
param cosmosDbAccountName string
param cosmosDbDatabaseName string
param tags object

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDbAccountName
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' existing = {
  name: cosmosDbDatabaseName
  parent: cosmosDbAccount

}

resource cosmosDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-11-15' = {
  name: cosmosDbContainerName
  parent: cosmosDbDatabase
  tags: tags
  properties: {
    resource: {
      id: cosmosDbContainerName
      partitionKey: {
        paths: [
          partitionKeyPath
        ]
        kind: 'Hash'
      }
    }
  }
}

output id string = cosmosDbContainer.id
output name string = cosmosDbContainer.name
