param cosmosDbDatabaseName string
param cosmosDbAccountName string

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDbAccountName
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  name: cosmosDbDatabaseName
  parent: cosmosDb
  properties: {
    resource: {
      id: cosmosDbDatabaseName
    }
  }
}

output id string = cosmosDbDatabase.id
output name string = cosmosDbDatabase.name
