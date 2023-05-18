param containerAppsEnvironmentName string
param logAnalyticsWorkspaceName string
param region string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource acaEnvironment 'Microsoft.App/managedEnvironments@2022-11-01-preview' = {
  name: containerAppsEnvironmentName
  location: region
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalytics.name, logAnalytics.apiVersion).customerId
        sharedKey: reference(logAnalytics.name, logAnalytics.apiVersion).primarySharedKey
      }
    }
  }
}

output id string = acaEnvironment.id
output name string = acaEnvironment.name
