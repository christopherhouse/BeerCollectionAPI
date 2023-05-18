param region string
param buildId string
param cosmosDbAccountName string
param cosmosDbDatabaseName string
param cosmosDbContainerName string
param partitionKey string

var cosmosDbDeploymentName = '${cosmosDbAccountName}-${buildId}'
var cosmosDbDatabaseDeploymentName = '${cosmosDbDatabaseName}-${buildId}'
var cosmosDbContainerDeploymentName = '${cosmosDbContainerName}-${buildId}'

module cosmosDb './modules/cosmosDbAccount.bicep' = {
  name: cosmosDbDeploymentName
  params: {
    region: region
    cosmosDbAccountName: cosmosDbAccountName
  }
}

module cosmosDbDatabase './modules/cosmosDbDatabase.bicep' = {
  name: cosmosDbDatabaseDeploymentName
  params: {
    cosmosDbAccountName: cosmosDb.name
    cosmosDbDatabaseName: cosmosDbDatabaseName
  }
}

module cosmosDbContainer './modules/cosmosDbContainer.bicep' = {
  name: cosmosDbContainerDeploymentName
  params: {
    cosmosDbDatabaseName: cosmosDbDatabase.name
    cosmosDbContainerName: cosmosDbContainerName
    partitionKey: partitionKey
  }
}
