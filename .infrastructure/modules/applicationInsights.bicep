param appInsightsName string
param region string
param logAnalyticsWorkspaceResourceId string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: region
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceResourceId
    Flow_Type: 'Bluefield'
  }
}

output id string = appInsights.id
output name string = appInsights.name
output apiVersion string = appInsights.apiVersion
