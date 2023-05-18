param region string
param buildId string
param cosmosDbAccountName string
param cosmosDbDatabaseName string
param cosmosDbContainerName string
param partitionKeyPath string
param keyVaultName string
param logAnalyticsWorkspaceName string
param containerAppsEnvironmentName string

var cosmosDbDeploymentName = '${cosmosDbAccountName}-${buildId}'
var cosmosDbDatabaseDeploymentName = '${cosmosDbDatabaseName}-${buildId}'
var cosmosDbContainerDeploymentName = '${cosmosDbContainerName}-${buildId}'
var keyVaultDeploymentName = '${keyVaultName}-${buildId}'
var logAnalyticsWorkspaceDeploymentName = '${logAnalyticsWorkspaceName}-${buildId}'
var containerAppsEnvironmentDeploymentName = '${containerAppsEnvironmentName}-${buildId}'

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
    cosmosDbAccountName: cosmosDb.outputs.name
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

module logAnalyticsWorkspace './modules/logAnalyticsWorkspace.bicep' = {
  name: logAnalyticsWorkspaceDeploymentName
  params: {
    region: region
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module acaEnvironment './modules/containerAppsEnvironment.bicep' = {
  name: containerAppsEnvironmentDeploymentName
  params: {
    region: region
    containerAppsEnvironmentName: containerAppsEnvironmentName
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.outputs.name
  }
}
