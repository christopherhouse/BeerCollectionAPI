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
param containerAppUserAssignedManagedIdentityName string
param redisCacheName string
param containerAppAppInsightsName string
param apimAppInsightsName string
param environmentName string
param apimUserAssignedManagedIdentityName string
param deploymentDate string = utcNow('yyyy-MM-ddTHH:mm:ssZ')

// Variables for module deployment names
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
var containerAppUserAssignedManagedIdentityDeploymentName = '${containerAppUserAssignedManagedIdentityName}-${buildId}'
var redisCacheDeploymentName = '${redisCacheName}-${buildId}'
var acrPullAssignmentDeploymentName = 'acrPullAssignment-${buildId}'
var containerAppAppInsightsDeploymentName = '${containerAppAppInsightsName}-${buildId}'
var apimAppInsightsDeploymentName = '${apimAppInsightsName}-${buildId}'
var apimUserAssignedManagedIdentityDeploymentName = '${apimUserAssignedManagedIdentityName}-${buildId}'

var tags = {
  Environment: environmentName
  Last_Deployment_Date: deploymentDate
  Owner: 'chhouse@microsoft.com'
  Build_ID: buildId
}

module cosmosDb './modules/cosmosDbAccount.bicep' = {
  name: cosmosDbDeploymentName
  params: {
    region: region
    cosmosDbAccountName: cosmosDbAccountName
    tags: tags
  }
}

module cosmosDbDatabase './modules/cosmosDbDatabase.bicep' = {
  name: cosmosDbDatabaseDeploymentName
  params: {
    cosmosDbAccountName: cosmosDb.outputs.name
    cosmosDbDatabaseName: cosmosDbDatabaseName
    tags: tags
  }
}

module cosmosDbContainer './modules/cosmosDbContainer.bicep' = {
  name: cosmosDbContainerDeploymentName
  params: {
    cosmosDbAccountName: cosmosDb.outputs.name
    cosmosDbDatabaseName: cosmosDbDatabase.outputs.name
    cosmosDbContainerName: cosmosDbContainerName
    partitionKeyPath: partitionKeyPath
    tags: tags
  }
}

module containerAppUserAssignedManagedIdentity './modules/userAssignedManagedIdentity.bicep' = {
  name: containerAppUserAssignedManagedIdentityDeploymentName
  params: {
    region: region
    name: containerAppUserAssignedManagedIdentityName
    tags: tags
  }
}

module apimUserAssignedManagedIdentity './modules/userAssignedManagedIdentity.bicep' = {
  name: apimUserAssignedManagedIdentityDeploymentName
  params: {
    region: region
    name: apimUserAssignedManagedIdentityName
    tags: tags
  }
}

module keyVault './modules/keyVault.bicep' = {
  name: keyVaultDeploymentName
  params: {
    region: region
    keyVaultName: keyVaultName
    applicationIds: [
      containerAppUserAssignedManagedIdentity.outputs.principalId
      apimUserAssignedManagedIdentity.outputs.principalId
    ]
    tags: tags
  }
}

module logAnalyticsWorkspace './modules/logAnalyticsWorkspace.bicep' = {
  name: logAnalyticsWorkspaceDeploymentName
  params: {
    region: region
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    tags: tags
  }
}

module registry './modules/containerRegistry.bicep' = {
  name: containerRegistryDeploymentName
  params: {
    region: region
    containerRegistryName: containerRegistryName
    tags: tags
  }
}

module acrPullAssignment './modules/acrPullRoleAssignment.bicep' = {
  name: acrPullAssignmentDeploymentName
  params: {
    containerRegistryName: registry.outputs.name
    userAssignedIdentityPrincipalId: containerAppUserAssignedManagedIdentity.outputs.principalId
  }
}

module acaEnvironment './modules/containerAppsEnvironment.bicep' = {
  name: containerAppsEnvironmentDeploymentName
  params: {
    region: region
    containerAppsEnvironmentName: containerAppsEnvironmentName
    logAnalyticsWorkspaceName: logAnalyticsWorkspace.outputs.name
    tags: tags
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
    userAssignedManagedIdentityId: containerAppUserAssignedManagedIdentity.outputs.id
    cosmosDbConnectionStringSecretUri: secrets.outputs.cosmosDbSecretUri
    cosmosDbDatabaseName: cosmosDbDatabase.outputs.name
    tags: tags
  }
}

module apiManagement './modules/apiManagement.bicep' = {
  name: apiManagementDeploymentName
  params: {
    region: region
    apiManagementServiceName: apiManagementServiceName
    publisherEmail: apiManagementPublisherEmail
    publisherName: apiManagementPublisherName
    userAssignedManagedIdentityId: apimUserAssignedManagedIdentity.outputs.id
    tags: tags
  }
}

module secrets './modules/secrets.bicep' = {
  name: secretsDeploymentName
  params: {
    keyVaultName: keyVault.outputs.name
    cosmosDbName: cosmosDb.outputs.name
    containerRegistryName: registry.outputs.name
    apimAppInsightsName: appInsightsApim.outputs.name
    containerAppsAppInsightsName: appInsightsContainerApp.outputs.name
    redisCacheName: redis.outputs.name
    tags: tags
  }
}

module redis './modules/redis.bicep' = {
  name: redisCacheDeploymentName
  params: {
    redisCacheName: redisCacheName
    region: region
    tags: tags
  }
}

module appInsightsApim './modules/applicationInsights.bicep' = {
  name: apimAppInsightsDeploymentName
  params:{
    appInsightsName: apimAppInsightsName
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.id
    region: region
    tags: tags
  }
}

module appInsightsContainerApp './modules/applicationInsights.bicep' = {
  name: containerAppAppInsightsDeploymentName
  params:{
    appInsightsName: containerAppAppInsightsName
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.id
    region: region
    tags: tags
  }
}
