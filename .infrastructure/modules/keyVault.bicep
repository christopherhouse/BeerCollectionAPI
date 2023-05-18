param keyVaultName string
param region string

var myObjectId = 'c9be89aa-0783-4310-b73a-f81f4c3f5407' // My AAD object ID

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
