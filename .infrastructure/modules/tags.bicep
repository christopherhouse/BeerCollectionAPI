param environmentName string
param deploymentDate string
param owner string
param buildId string

var tags = {
    Environment: environmentName
    Last_Deployment_Date: deploymentDate
    Owner: owner
    Build_Id: buildId
}

output tags object = tags
