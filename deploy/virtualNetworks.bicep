param name string
param location string
param addressPrefixes array
param subnets array

param logAnalyticsId string

var serviceLogs = [
  {
    enabled: true
    categoryGroup: 'allLogs'
  }
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
        serviceEndpoints: subnet.serviceEndpoints
      }
    }]
  }
}

resource virtualNetworkDiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'service'
  scope: virtualNetwork
  properties: {
    workspaceId: logAnalyticsId
    logs: serviceLogs
  }
}

output virtualNetworkName string = virtualNetwork.name
output virtualNetworkId string = virtualNetwork.id
