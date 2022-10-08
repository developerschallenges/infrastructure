param acsName string
param acsLocation string
param indexName string
@secure()
param githubSecretsPat string

resource acs 'Microsoft.Search/searchServices@2021-04-01-preview' = {
  name: acsName
  location: acsLocation
  sku: {
    name: 'free'
  }
}

// resource acsScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'acsScript'
//   location: acsLocation
//   kind: 'AzurePowerShell'
//   properties: {
//     azPowerShellVersion: '6.4'
//     cleanupPreference: 'Always'
//     retentionInterval: 'PT1H'
//     arguments: '-acsName ${acsName} -adminKey ${acs.listAdminKeys().primaryKey} -indexName ${indexName}'
//     scriptContent: '''
// param([string] $acsName, [string] $adminKey, [string] $indexName)
// curl -H "api-key: $adminKey" -H "Content-Type: application/json" -d @"
// { \"name\": \"$indexName\", \"fields\": [{ \"name\": \"id\", \"type\": \"Edm.String\", \"key\": true, \"retrievable\": true, \"filterable\": false, \"sortable\": false, \"facetable\": false, \"searchable\": false }], \"suggesters\": [ ], \"scoringProfiles\": [ ] }
// "@ -X POST https://$acsName.search.windows.net/indexes?api-version=2020-06-30
//     '''
//   }
// }

resource acsScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'acsKeysToGithubSecrets'
  location: acsLocation
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '6.4'
    cleanupPreference: 'Always'
    retentionInterval: 'PT1H'
    arguments: '-githubSecretsPat ${githubSecretsPat} -acsAdminKey ${acs.listAdminKeys().primaryKey}'
    scriptContent: '''
$keyId=(curl -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $githubSecretsPat" https://api.github.com/orgs/developerschallenges/actions/secrets/public-key | ConvertFrom-Json).key_id
curl -X PUT -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $githubSecretsPat" https://api.github.com/orgs/developerschallenges/actions/secrets/ACS_ADMIN_KEY -d @"
{\"encrypted_value\":\"$acsAdminKey\","key_id":\"$keyId\","visibility":"all"}'
"@
    '''
  }
}

output searchServiceName string = acs.name
// #disable-next-line outputs-should-not-contain-secrets
// output searchAdminKey string = acs.listAdminKeys().primaryKey
#disable-next-line outputs-should-not-contain-secrets
output searchQueryKey string = acs.listQueryKeys().value[0].key
output searchIndexName string = indexName
