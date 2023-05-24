param containerAppName string
param region string
param containerAppEnvironmentId string
param registry string
param containerName string
param containerVersion string
param userAssignedManagedIdentityId string
param cosmosDbConnectionStringSecretUri string

var containerImage = '${acr.properties.loginServer}/${containerName}:${containerVersion}'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: registry
}

resource containerApp 'Microsoft.App/containerApps@2022-11-01-preview' = {
  name: containerAppName
  location: region
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityId}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        targetPort: 80
        external: true
      }
      registries: [
        {
          server: acr.properties.loginServer
          username: acr.name
          passwordSecretRef: 'acr-password'
        }
      ]
      secrets: [
        {
          name: 'acr-password'
          value: acr.listCredentials().passwords[0].value
        }
        {
          name: 'cosmosConnectionString'
          keyVaultUrl: cosmosDbConnectionStringSecretUri
        }
      ]      
    }
    template: {
      containers: [
        {
          image: containerImage
          name: 'beer-api'
          probes: [
            {
              type: 'Liveness'
              httpGet: {
                path: '/healthz'
                port: 80
              }
              initialDelaySeconds: 20
              periodSeconds: 10
            }
          ]
        }
      ]
    }    
  }
}

output id string = containerApp.id
output name string = containerApp.name
output apiVersion string = containerApp.apiVersion
