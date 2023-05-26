param redisCacheName string
param region string
param tags object

resource redis 'Microsoft.Cache/redis@2022-06-01' = {
  name: redisCacheName
  location: region
  tags: tags
  properties: {
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    sku:{
      name: 'Basic'
      capacity: 0
      family: 'C'
    }
  }
}

output id string = redis.id
output name string = redis.name
output apiVersion string = redis.apiVersion
