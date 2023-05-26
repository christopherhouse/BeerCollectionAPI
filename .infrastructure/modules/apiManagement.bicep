param apiManagementServiceName string
param publisherEmail string
param publisherName string
param region string
param tags object

resource apim 'Microsoft.ApiManagement/service@2022-09-01-preview' = {
  name: apiManagementServiceName
  location: region
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

output id string = apim.id
output name string = apim.name
output principalId string = apim.identity.principalId
