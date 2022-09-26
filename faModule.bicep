param faName string = 'fa-developerschallenges2'
param faLocation string

param saName string = 'sadeveloperschallenges2'

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param saType string = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: saName
  location: faLocation
  sku: {
    name: saType
  }
  kind: 'Storage'
}

param aspName string = 'asp-developerschallenges2'

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: aspName
  location: faLocation
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource fa 'Microsoft.Web/sites@2022-03-01' = {
  name: faName
  location: faLocation
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: hostingPlan.id
    httpsOnly: true
    siteConfig: {
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~16'
        }
      ]
    }
  }
}
