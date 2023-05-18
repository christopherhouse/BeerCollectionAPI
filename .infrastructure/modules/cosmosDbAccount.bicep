param cosmosDbAccountName string
param region string

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' = {
  name: cosmosDbAccountName
  location: region
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: region
        failoverPriority: 0
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
}

output id string = cosmosdb.id
output name string = cosmosdb.name
output apiVersion string = cosmosdb.apiVersion
