param workloadName string
param resourceNamePrefix string
param environmentName string

var cosmosDbAccountName = '${resourceNamePrefix}-${workloadName}-cdb-${environmentName}'

output cosmosDbAccountName string = cosmosDbAccountName
