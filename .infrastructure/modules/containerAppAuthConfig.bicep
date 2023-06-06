param containerAppName string
@secure()
param clientId string
param clientSecretSecretName string
@secure()
param tokenIssuer string

resource containerApp 'Microsoft.App/containerApps@2022-11-01-preview' existing = {
  name: containerAppName
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
          clientId: clientId
          clientSecretSettingName: clientSecretSecretName
          openIdIssuer: tokenIssuer
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
