param logAnalyticsWorkspaceName string
param region string
param tags object

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2015-11-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: region
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output id string = logAnalytics.id
output name string = logAnalytics.name
