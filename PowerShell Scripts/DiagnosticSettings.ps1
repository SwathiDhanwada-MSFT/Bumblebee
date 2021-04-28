param(
    [string] $workspaceId,
    [string] $azDiagName,
    [string] $metricsEnabled,
    [string] $logsEnabled
)

$azResources = Get-AzResource -ResourceType 'Microsoft.Web/sites'

foreach ($azResource in $azResources) {
    $resourceId     = $azResource.ResourceId
    $azDiagSettings = Get-AzDiagnosticSetting -ResourceId $resourceId 

    if([string]::IsNullOrEmpty($azDiagSettings)){
        Set-AzDiagnosticSetting -ResourceId $resourceId -WorkspaceId $workspaceId -Name $azDiagName -EnableLog $logsEnabled -EnableMetrics $metricsEnabled
    }
    else{
        foreach ($azDiag in $azDiagSettings) {
            If (!($azDiag.WorkspaceId -eq $workspaceId -and $azDiag.Name -eq $azDiagName)) {
                Remove-AzDiagnosticSetting -ResourceId $resourceId -Name $azDiag.Name
                Set-AzDiagnosticSetting -ResourceId $resourceId -WorkspaceId $workspaceId -Name $azDiagName -EnableLog $logsEnabled -EnableMetrics $metricsEnabled
            }         
        }
    }
}
