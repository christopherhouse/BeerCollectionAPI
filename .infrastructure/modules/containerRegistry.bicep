param containerRegistryName string
param region string

resource registry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: containerRegistryName
  location: region
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

output id string = registry.id
output name string = registry.name
