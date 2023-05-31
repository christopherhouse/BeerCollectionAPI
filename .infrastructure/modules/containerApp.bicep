param containerAppName string
param region string
param containerAppEnvironmentId string
param registry string
param containerName string
param containerVersion string
param userAssignedManagedIdentityId string
param cosmosDbConnectionStringSecretUri string
param cosmosDbDatabaseName string
param tags object

var containerImage = '${acr.properties.loginServer}/${containerName}:${containerVersion}'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: registry
}

resource containerApp 'Microsoft.App/containerApps@2022-11-01-preview' = {
  name: containerAppName
  location: region
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityId}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      activeRevisionsMode: 'Multiple'
      ingress: {
        targetPort: 80
        external: true
      }
      registries: [
        {
          server: acr.properties.loginServer
          identity: userAssignedManagedIdentityId
        }
      ]
      secrets: [
        {
          name: 'cosmos-database-name'
          value: cosmosDbDatabaseName
        }
        {
          name: 'cosmos-connection-string'
          keyVaultUrl: cosmosDbConnectionStringSecretUri
          identity: userAssignedManagedIdentityId
        }
      ]      
    }
    template: {
      containers: [
        {
          image: containerImage
          name: 'beer-api'
          env: [
            {
              name: 'cosmos-connection-string'
              secretRef: 'cosmos-connection-string'
            }
            {
              name: 'cosmos-database-name'
              secretRef: 'cosmos-database-name'
            }
          ]
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
