[string] [Parameter(Mandatory=$false)] $workspaceId,
[string] [Parameter(Mandatory=$false)] $azDiagName,
[string] [Parameter(Mandatory=$false)] $ResourceId

$azResources = Get-AzResource -ResourceType 'Microsoft.Web/Sites' -ResourceId $ResourceId

foreach ($azResource in $azResources) {
    $resourceId     = $azResource.ResourceId
    $azDiagSettings = Get-AzDiagnosticSetting -ResourceId $resourceId 

    if($azDiagSettings -eq $null){
        Set-AzDiagnosticSetting -ResourceId $resourceId -WorkspaceId $workspaceId -Name $azDiagName -Enabled $true
    }
    else{
        foreach ($azDiag in $azDiagSettings) {
            If (!($azDiag.WorkspaceId -eq $workspaceId -and $azDiag.Name -eq $azDiagName)) {
                Remove-AzDiagnosticSetting -ResourceId $resourceId -Name $azDiag.Name
                Set-AzDiagnosticSetting -ResourceId $resourceId -WorkspaceId $workspaceId -Name $azDiagName -Enabled $true
            }         
        }
    }
}
