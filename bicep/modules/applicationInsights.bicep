
@description('Location to deploy the resources')
param location string = resourceGroup().location

@description('Log Analytics workspace id to use for diagnostics settings')
param logAnalyticsWorkspaceId string

var applicationInsightsName = '${resourceGroup().name}-ai-${uniqueString(resourceGroup().id)}'
var applicationInsightsDiagnosticsName = '${resourceGroup().name}-ai-diag-${uniqueString(resourceGroup().id)}'

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

resource applicationInsightsDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: applicationInsights
  name: applicationInsightsDiagnosticsName
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    logs: [
      {
        category: 'AppAvailabilityResults'
        enabled: true
      }
      {
        category: 'AppBrowserTimings'
        enabled: true
      }
      {
        category: 'AppEvents'
        enabled: true
      }
      {
        category: 'AppMetrics'
        enabled: true
      }
      {
        category: 'AppDependencies'
        enabled: true
      }
      {
        category: 'AppExceptions'
        enabled: true
      }
      {
        category: 'AppPageViews'
        enabled: true
      }
      {
        category: 'AppPerformanceCounters'
        enabled: true
      }
      {
        category: 'AppRequests'
        enabled: true
      }
      {
        category: 'AppSystemEvents'
        enabled: true
      }
      {
        category: 'AppTraces'
        enabled: true
      }
    ]
  }
}

output InstrumentationKey string = applicationInsights.properties.InstrumentationKey
output ConnectionString string = applicationInsights.properties.ConnectionString