targetScope = 'subscription'

param rgName string
param rgLocation string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
}

module acsModule 'acsModule.bicep' = {
  name: 'acsModule'
  scope: rg
  params: {
    acsLocation: rgLocation
  }
}
