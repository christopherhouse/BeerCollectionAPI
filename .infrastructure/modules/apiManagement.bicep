param apiManagementServiceName string
param publisherEmail string
param publisherName string
param region string

resource apim 'Microsoft.ApiManagement/service@2022-09-01-preview' = {
  name: apiManagementServiceName
  location: region
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
