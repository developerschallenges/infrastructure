param acsName string = 'acs-developerschallenges2'
param acsLocation string

resource acs 'Microsoft.Search/searchServices@2021-04-01-preview' = {
  name: acsName
  location: acsLocation
  sku: {
    name: 'free'
  }
}

output searchServiceName string = acs.name
#disable-next-line outputs-should-not-contain-secrets 
//output searchApiKey string = acs.listAdminKeys().primaryKey
#disable-next-line outputs-should-not-contain-secrets 
output queryKey string = acs.listQueryKeys().value[0].key
