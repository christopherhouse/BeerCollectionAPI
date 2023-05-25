param containerRegistryName string
param userAssignedIdentityPrincipalId string

var acrPullRoleDefinitionId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: containerRegistryName
}

resource roleDefintion 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup()
  name: acrPullRoleDefinitionId
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: acr
  name: guid(acr.id, userAssignedIdentityPrincipalId, acrPullRoleDefinitionId)
  properties: {
    roleDefinitionId: roleDefintion.id
    principalId: userAssignedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}
