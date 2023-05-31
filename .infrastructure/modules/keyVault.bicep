param keyVaultName string
param region string
param applicationIds array
param tags object

var myObjectId = 'c9be89aa-0783-4310-b73a-f81f4c3f5407' // My AAD object ID

var appAccessPolicies = [for app in applicationIds: {
  tenantId: subscription().tenantId
  objectId: app
  permissions: {
    secrets: [
      'get'
      'list'
    ]
  }
}]

var userAccessPolicies = [{
  tenantId: subscription().tenantId
  objectId: myObjectId
  permissions: {
    secrets: [
      'all'
    ]
    keys: [
      'all'
    ]
    certificates: [
      'all'
    ]
  }
}
]

var accessPolicies = union(appAccessPolicies, userAccessPolicies)

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: region
  tags: tags
  properties: {
    accessPolicies: accessPolicies
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
      family: 'A'
    }
  }
}

output id string = keyVault.id
output name string = keyVault.name
output apiVersion string = keyVault.apiVersion
output keyVaultUri string = keyVault.properties.vaultUri
