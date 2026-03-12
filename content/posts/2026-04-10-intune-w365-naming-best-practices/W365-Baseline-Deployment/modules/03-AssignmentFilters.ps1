<#
.SYNOPSIS
    Module 03 - Create Intune Assignment Filters for Windows 365.

.DESCRIPTION
    Creates device assignment filters to target Cloud PC devices.
    Skips filters that already exist (matched by displayName).

.NOTES
    Requires: Microsoft.Graph.DeviceManagement
#>

function Deploy-W365AssignmentFilters {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [array]$FilterDefinitions
    )

    Write-Host "`n[03-Filters] Deploying Intune assignment filters..." -ForegroundColor Cyan
    $createdFilters = @{}

    foreach ($filterDef in $FilterDefinitions) {
        $displayName = $filterDef.displayName
        Write-Host "  Checking: $displayName" -ForegroundColor Gray

        # Check if filter already exists
        $uri = "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters?`$filter=displayName eq '$displayName'"
        $existing = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue

        if ($existing.value -and $existing.value.Count -gt 0) {
            Write-Host "  [SKIP] Filter already exists: $displayName" -ForegroundColor Yellow
            $createdFilters[$displayName] = $existing.value[0].id
            continue
        }

        $filterBody = @{
            displayName = $displayName
            description = $filterDef.description
            platform    = $filterDef.platform
            rule        = $filterDef.rule
        }

        $result = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters" `
            -Body ($filterBody | ConvertTo-Json -Depth 5) `
            -ContentType "application/json"

        Write-Host "  [CREATED] $displayName (ID: $($result.id))" -ForegroundColor Green
        $createdFilters[$displayName] = $result.id
    }

    Write-Host "[03-Filters] Complete. $($createdFilters.Count) filters processed.`n" -ForegroundColor Cyan
    return $createdFilters
}

Export-ModuleMember -Function Deploy-W365AssignmentFilters
