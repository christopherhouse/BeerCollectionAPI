param redisCacheName string
param region string

resource redis 'Microsoft.Cache/redis@2022-06-01' = {
  name: redisCacheName
  location: region
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
