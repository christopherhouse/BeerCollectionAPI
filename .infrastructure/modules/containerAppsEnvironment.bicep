param containerAppsEnvironmentName string
param logAnalyticsWorkspaceName string
param region string
param tags object

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource acaEnvironment 'Microsoft.App/managedEnvironments@2022-11-01-preview' = {
  name: containerAppsEnvironmentName
  location: region
  tags: tags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
  }
}

output id string = acaEnvironment.id
output name string = acaEnvironment.name
