param cosmosDbDatabaseName string
param cosmosDbAccountName string
param tags object

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDbAccountName
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' = {
  name: cosmosDbDatabaseName
  parent: cosmosDb
  tags: tags
  properties: {
    resource: {
      id: cosmosDbDatabaseName
    }
  }
}

output id string = cosmosDbDatabase.id
output name string = cosmosDbDatabase.name
