param acsName string
param acsLocation string
param indexName string

resource acs 'Microsoft.Search/searchServices@2021-04-01-preview' = {
  name: acsName
  location: acsLocation
  sku: {
    name: 'free'
  }
}

output searchServiceName string = acs.name
#disable-next-line outputs-should-not-contain-secrets
output searchQueryKey string = acs.listQueryKeys().value[0].key
output searchIndexName string = indexName
