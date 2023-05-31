param appInsightsName string
param region string
param logAnalyticsWorkspaceResourceId string
param tags object

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: region
  tags: tags
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
