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

resource acsScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'acsScript'
  location: acsLocation
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '6.4'
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
    arguments: '-acsName ${acsName} -adminKey ${acs.listAdminKeys().primaryKey} -indexName ${indexName}'
    scriptContent: '''
      param([string] $acsName, [string] $adminKey, [string] $indexName)
      curl -H "api-key: $adminKey" -H "Content-Type: application/json" -d @"
      { \"name\": \"$indexName\", \"fields\": [{ \"name\": \"id\", \"type\": \"Edm.String\", \"key\": true, \"retrievable\": true, \"filterable\": false, \"sortable\": false, \"facetable\": false, \"searchable\": false }], \"suggesters\": [ ], \"scoringProfiles\": [ ] }
      "@ -X POST https://$acsName.search.windows.net/indexes?api-version=2020-06-30
    '''
  }
}

output searchServiceName string = acs.name
#disable-next-line outputs-should-not-contain-secrets 
//output searchApiKey string = acs.listAdminKeys().primaryKey
#disable-next-line outputs-should-not-contain-secrets 
output queryKey string = acs.listQueryKeys().value[0].key
output searchIndexName string = indexName
