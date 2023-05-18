param region string
param buildId string
param cosmosDbAccountName string

var cosmosDbDeploymentName = '${cosmosDbAccountName}-${buildId}'

module cosmosDb './modules/cosmosDb.bicep' = {
  name: cosmosDbDeploymentName
  params: {
    region: region
    cosmosDbAccountName: cosmosDbAccountName
  }
}
