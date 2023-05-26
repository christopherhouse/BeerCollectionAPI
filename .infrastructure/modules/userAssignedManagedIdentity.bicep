param name string
param region string
param tags object

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: name
  location: region
  tags: tags
}

output id string = identity.id
output name string = identity.name
output apiVersion string = identity.apiVersion
output principalId string = identity.properties.principalId
