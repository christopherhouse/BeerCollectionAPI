param region string
param buildId string
param cosmosDbAccountName string
param cosmosDbDatabaseName string
param cosmosDbContainerName string
param partitionKeyPath string
param keyVaultName string
param logAnalyticsWorkspaceName string
param containerAppsEnvironmentName string
param containerRegistryName string
param apiManagementServiceName string
param apiManagementPublisherEmail string
param apiManagementPublisherName string
param containerAppName string
param containerName string
param containerTagVersion string

var cosmosDbDeploymentName = '${cosmosDbAccountName}-${buildId}'
var cosmosDbDatabaseDeploymentName = '${cosmosDbDatabaseName}-${buildId}'
var cosmosDbContainerDeploymentName = '${cosmosDbContainerName}-${buildId}'
var keyVaultDeploymentName = '${keyVaultName}-${buildId}'
var logAnalyticsWorkspaceDeploymentName = '${logAnalyticsWorkspaceName}-${buildId}'
var containerAppsEnvironmentDeploymentName = '${containerAppsEnvironmentName}-${buildId}'
var containerRegistryDeploymentName = '${containerRegistryName}-${buildId}'
var apiManagementDeploymentName = '${apiManagementServiceName}-${buildId}'
var containerAppDeploymentName = '${containerAppName}-${buildId}'

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

module registry './modules/containerRegistry.bicep' = {
  name: containerRegistryDeploymentName
  params: {
    region: region
    containerRegistryName: containerRegistryName
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

module containerApp './modules/containerApp.bicep' = {
  name: containerAppDeploymentName
  params: {
    containerAppEnvironmentId: acaEnvironment.outputs.id
    containerAppName: containerAppName
    containerName: containerName
    containerVersion: containerVersion
    region: region
    registry: registry.outputs.name
  }
}

module apiManagement './modules/apiManagement.bicep' = {
  name: apiManagementDeploymentName
  params: {
    region: region
    apiManagementServiceName: apiManagementServiceName
    publisherEmail: apiManagementPublisherEmail
    publisherName: apiManagementPublisherName
  }
}
