param containerAppName string
param region string
param containerAppEnvironmentId string
param registry string
param containerName string
param containerVersion string

var containerImage = '${acr.properties.loginServer}/${containerName}:${containerVersion}'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: registry
}

resource containerApp 'Microsoft.App/containerApps@2022-11-01-preview' = {
  name: containerAppName
  location: region
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        targetPort: 80
        external: true
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: 'beer-api'

        }
      ]
    }
    registries: [
      {
        name: registry
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
    ]
  }
}
