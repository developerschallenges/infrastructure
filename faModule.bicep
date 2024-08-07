param faName string
param faLocation string
param faCors string

param saName string
@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param saType string = 'Standard_LRS'

param aspName string

param aiInstrumentationKey string

param searchServiceName string
param searchIndexName string
param searchApiKey string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: saName
  location: faLocation
  sku: {
    name: saType
  }
  kind: 'Storage'
}

resource hostingPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: aspName
  location: faLocation
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource fa 'Microsoft.Web/sites@2023-12-01' = {
  name: faName
  location: faLocation
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: hostingPlan.id
    httpsOnly: true
    siteConfig: {
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      cors: {
        allowedOrigins: [
          faCors
        ]
      }
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${saName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${saName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(faName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~20'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: aiInstrumentationKey
        }
        {
          name: 'SearchServiceName'
          value: searchServiceName
        }
        {
          name: 'SearchIndexName'
          value: searchIndexName
        }
        {
          name: 'SearchApiKey'
          value: searchApiKey
        }
      ]
    }
  }
}
