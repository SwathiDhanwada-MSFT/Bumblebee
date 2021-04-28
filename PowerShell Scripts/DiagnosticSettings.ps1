#[string] [Parameter(Mandatory=$false)] $workspaceId,
#[string] [Parameter(Mandatory=$false)] $azDiagName

param(
    [string] $workspaceId,
    [string] $azDiagName
)

$azResources = Get-AzResource -ResourceType 'Microsoft.Web/sites'

Write-Output $azResources

Write-Output $workspaceId
Write-Output $azDiagName

foreach ($azResource in $azResources) {
    $resourceId     = $azResource.ResourceId
    Write-Output $resourceId
    $azDiagSettings = Get-AzDiagnosticSetting -ResourceId $resourceId 
    Write-Output $azDiagSettings

    if([string]::IsNullOrEmpty($azDiagSettings)){
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
