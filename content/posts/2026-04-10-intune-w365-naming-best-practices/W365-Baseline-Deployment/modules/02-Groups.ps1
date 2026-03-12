<#
.SYNOPSIS
    Module 02 - Create Entra ID Security Groups for Windows 365.

.DESCRIPTION
    Creates security groups (assigned or dynamic) based on the config file.
    Skips groups that already exist (matched by displayName).

.NOTES
    Requires: Microsoft.Graph.Groups
#>

function Deploy-W365Groups {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [array]$GroupDefinitions
    )

    Write-Host "`n[02-Groups] Deploying Entra ID security groups..." -ForegroundColor Cyan
    $createdGroups = @{}

    foreach ($groupDef in $GroupDefinitions) {
        $displayName = $groupDef.displayName
        Write-Host "  Checking: $displayName" -ForegroundColor Gray

        # Check if group already exists
        $existingGroup = Get-MgGroup -Filter "displayName eq '$displayName'" -ErrorAction SilentlyContinue |
            Select-Object -First 1

        if ($existingGroup) {
            Write-Host "  [SKIP] Group already exists: $displayName (ID: $($existingGroup.Id))" -ForegroundColor Yellow
            $createdGroups[$displayName] = $existingGroup.Id
            continue
        }

        # Build group body
        $groupBody = @{
            displayName     = $displayName
            description     = $groupDef.description
            mailEnabled     = $false
            mailNickname    = ($displayName -replace '[^a-zA-Z0-9]', '')
            securityEnabled = $true
        }

        if ($groupDef.membershipType -eq "Dynamic" -and $groupDef.membershipRule) {
            $groupBody.groupTypes = @("DynamicMembership")
            $groupBody.membershipRule = $groupDef.membershipRule
            $groupBody.membershipRuleProcessingState = "On"
        }

        $newGroup = New-MgGroup -BodyParameter $groupBody
        Write-Host "  [CREATED] $displayName (ID: $($newGroup.Id))" -ForegroundColor Green
        $createdGroups[$displayName] = $newGroup.Id
    }

    Write-Host "[02-Groups] Complete. $($createdGroups.Count) groups processed.`n" -ForegroundColor Cyan
    return $createdGroups
}

Export-ModuleMember -Function Deploy-W365Groups
