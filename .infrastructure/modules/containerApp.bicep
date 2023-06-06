param containerAppName string
param region string
param containerAppEnvironmentId string
param registry string
param containerName string
param containerVersion string
param userAssignedManagedIdentityId string
param cosmosDbConnectionStringSecretUri string
param appInsightsConnectionStringSecretUri string
param appInsightsInstrumentationKeySecretUri string
param cosmosDbDatabaseName string
param identityProviderClientIdSecretName string
param identityProviderClientSecretSecretUri string
param identityProviderOpenIdIssuerSecretName string
param keyVaultName string
param tags object

var containerImage = '${acr.properties.loginServer}/${containerName}:${containerVersion}'
var appInsightsInstrumentationKeySecretName = 'appinsights-instrumentation-key'
var cosmosDbDatabaseNameSecretName = 'cosmos-database-name'
var cosmosDbConnectionStringSecretName = 'cosmos-connection-string'
var appInsightsConnectionStringSecretName = 'appinsights-connection-string'
var identityProviderClientSecretSecretName = 'identityProviderClientSecretSettingName'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: registry
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource tokenIssuerSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' existing = {
  name: identityProviderOpenIdIssuerSecretName
  parent: keyVault
}

resource clientIdSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' existing = {
  name: identityProviderClientIdSecretName
  parent: keyVault
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
          name: cosmosDbDatabaseNameSecretName
          value: cosmosDbDatabaseName
        }
        {
          name: cosmosDbConnectionStringSecretName
          keyVaultUrl: cosmosDbConnectionStringSecretUri
          identity: userAssignedManagedIdentityId
        }
        {
          name: appInsightsConnectionStringSecretName
          keyVaultUrl: appInsightsConnectionStringSecretUri
          identity: userAssignedManagedIdentityId
        }
        {
          name: appInsightsInstrumentationKeySecretName
          keyVaultUrl: appInsightsInstrumentationKeySecretUri
          identity: userAssignedManagedIdentityId
        }
        {
          name: identityProviderClientSecretSecretName
          keyVaultUrl: identityProviderClientSecretSecretUri
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
              secretRef: cosmosDbConnectionStringSecretName
            }
            {
              name: 'cosmos-database-name'
              secretRef: cosmosDbDatabaseNameSecretName
            }
            {
              name: 'appinsights-connection-string'
              secretRef: appInsightsConnectionStringSecretName
            }
            {
              name: 'ApplicationInsights__InstrumentationKey'
              secretRef: appInsightsInstrumentationKeySecretName
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
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 10
        rules: [
          {
            http: {
              metadata: {
                concurrentRequests: '30'
              }
            }
            name: 'scale-up-30-cx-reqs'
          }
        ]
      }
    }    
  }
}

resource authConfig 'Microsoft.App/containerApps/authConfigs@2022-11-01-preview' = {
  parent: containerApp
  name: 'current'
  properties: {
    globalValidation: {
      redirectToProvider: 'azureactivedirectory'
      unauthenticatedClientAction: 'RedirectToLoginPage'
    }
    identityProviders: {
      azureActiveDirectory: {
        isAutoProvisioned: false
        registration: {
          clientId: clientIdSecret.properties.value
          clientSecretSettingName: identityProviderClientSecretSecretName
          openIdIssuer: tokenIssuerSecret.properties.value
        }
      }
    }
    login: {
      preserveUrlFragmentsForLogins: false
    }
    platform: {
      enabled: true
    }
  }
}

output id string = containerApp.id
output name string = containerApp.name
output apiVersion string = containerApp.apiVersion
