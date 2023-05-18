param keyVaultName string
param region string

var myObjectId = ''

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: region
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: myObjectId
        permissions: {
          certificates: [
            'all'
          ]
          keys: [
            'all'
          ]
          secrets: [
            'all'
          ]
        }
      }
    ]
    enabledForTemplateDeployment: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Enabled'
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'}
  }
}
