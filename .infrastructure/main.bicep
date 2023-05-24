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
param containerVersionTag string
param userAssignedManagedIdentityName string

var cosmosDbDeploymentName = '${cosmosDbAccountName}-${buildId}'
var cosmosDbDatabaseDeploymentName = '${cosmosDbDatabaseName}-${buildId}'
var cosmosDbContainerDeploymentName = '${cosmosDbContainerName}-${buildId}'
var keyVaultDeploymentName = '${keyVaultName}-${buildId}'
var logAnalyticsWorkspaceDeploymentName = '${logAnalyticsWorkspaceName}-${buildId}'
var containerAppsEnvironmentDeploymentName = '${containerAppsEnvironmentName}-${buildId}'
var containerRegistryDeploymentName = '${containerRegistryName}-${buildId}'
var apiManagementDeploymentName = '${apiManagementServiceName}-${buildId}'
var containerAppDeploymentName = '${containerAppName}-${buildId}'
var secretsDeploymentName = 'secrets-${buildId}'
var userAssignedManagedIdentityDeploymentName = '${userAssignedManagedIdentityName}-${buildId}'

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

module userAssignedManagedIdentity './modules/userAssignedManagedIdentity.bicep' = {
  name: userAssignedManagedIdentityDeploymentName
  params: {
    region: region
    name: userAssignedManagedIdentityName
  }
}

module keyVault './modules/keyVault.bicep' = {
  name: keyVaultDeploymentName
  params: {
    region: region
    keyVaultName: keyVaultName
    applicationIds: [
      userAssignedManagedIdentity.outputs.principalId
    ]
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
    containerVersion: containerVersionTag
    region: region
    registry: registry.outputs.name
    userAssignedManagedIdentityId: userAssignedManagedIdentity.outputs.id
    cosmosDbConnectionStringSecretUri: secrets.outputs.cosmosDbSecretUri
    cosmosDbDatabaseName: cosmosDbDatabase.outputs.name
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

module secrets './modules/secrets.bicep' = {
  name: secretsDeploymentName
  params: {
    keyVaultName: keyVault.outputs.name
    cosmosDbName: cosmosDb.outputs.name
  }
}
