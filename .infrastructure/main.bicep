param region string
param buildId string
param cosmosDbAccountName string
param cosmosDbDatabaseName string
param cosmosDbContainerName string
param partitionKeyPath string
param keyVaultName string

var cosmosDbDeploymentName = '${cosmosDbAccountName}-${buildId}'
var cosmosDbDatabaseDeploymentName = '${cosmosDbDatabaseName}-${buildId}'
var cosmosDbContainerDeploymentName = '${cosmosDbContainerName}-${buildId}'
var keyVaultDeploymentName = '${keyVaultName}-${buildId}'

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
    cosmosDbAccountName: cosmosDb.outputs.name
    cosmosDbDatabaseName: cosmosDbDatabaseName
  }
}

module cosmosDbContainer './modules/cosmosDbContainer.bicep' = {
  name: cosmosDbContainerDeploymentName
  params: {
    cosmosDbAccountName: cosmosDb.name
    cosmosDbDatabaseName: cosmosDbDatabase.outputs.name
    cosmosDbContainerName: cosmosDbContainerName
    partitionKeyPath: partitionKeyPath
  }
}

module keyVault './modules/keyVault.bicep' = {
  name: keyVaultDeploymentName
  params: {
    region: region
    keyVaultName: keyVaultName
  }
}
