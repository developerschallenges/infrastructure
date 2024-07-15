param laName string
param laLocation string
param aiName string

resource la 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: laName
  location: laLocation
}

resource ai 'Microsoft.Insights/components@2020-02-02' = {
  name: aiName
  location: laLocation
  kind: 'web'
  properties: {
    WorkspaceResourceId: la.id
    Application_Type: 'web'
  }
}

output aiInstrumentationKey string = ai.properties.InstrumentationKey
