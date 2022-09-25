param acsName string = 'acs-developerschallenges2'
param acsLocation string

resource acs 'Microsoft.Search/searchServices@2021-04-01-preview' = {
  name: acsName
  location: acsLocation
  sku: {
    name: 'free'
  }
}
