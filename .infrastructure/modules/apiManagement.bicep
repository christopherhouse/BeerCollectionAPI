param apiManagementServiceName string
param publisherEmail string
param publisherName string
param region string
param userAssignedManagedIdentityId string
param tags object

resource apim 'Microsoft.ApiManagement/service@2022-09-01-preview' = {
  name: apiManagementServiceName
  location: region
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityId}': {}
    }
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

