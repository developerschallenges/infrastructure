targetScope = 'subscription'

param appName string
param appUrl string
param rgLocation string

var rgName = 'rg-${appName}'
var acsName = 'acs-${appName}'
var faName = 'fa-${appName}'
var saName = 'sa${appName}'
var aspName = 'asp-${appName}'
var laName = 'la-${appName}'
var aiName = 'ai-${appName}'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: rgLocation
}

module laModule 'laModule.bicep' = {
  name: 'laModule'
  scope: rg
  params: {
    laName: laName
    laLocation: rgLocation
    aiName: aiName
  }
}

module acsModule 'acsModule.bicep' = {
  name: 'acsModule'
  scope: rg
  params: {
    acsName: acsName
    acsLocation: rgLocation
    indexName: appName
  }
}

module faModule 'faModule.bicep' = {
  name: 'faModule'
  scope: rg
  params: {
    faName: faName
    faLocation: rgLocation
    faCors: appUrl
    saName: saName
    aspName: aspName
    searchServiceName: acsModule.outputs.searchServiceName
    searchIndexName: acsModule.outputs.searchIndexName
    searchApiKey: acsModule.outputs.searchQueryKey
    aiInstrumentationKey: laModule.outputs.aiInstrumentationKey
  }
}
