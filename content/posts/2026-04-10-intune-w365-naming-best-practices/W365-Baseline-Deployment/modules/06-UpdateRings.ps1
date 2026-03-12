<#
.SYNOPSIS
    Module 06 - Create Windows Update Rings for Windows 365 Cloud PCs.

.DESCRIPTION
    Creates Windows Update for Business ring policies with configurable
    quality and feature update deferral periods.
    Policies are created without assignments — assign manually after review.

.NOTES
    Requires: Microsoft.Graph.DeviceManagement
#>

function Deploy-W365UpdateRings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [array]$RingDefinitions
    )

    Write-Host "`n[06-UpdateRings] Deploying Windows Update rings..." -ForegroundColor Cyan
    $createdRings = @{}

    foreach ($ringDef in $RingDefinitions) {
        $displayName = $ringDef.displayName
        Write-Host "  Checking: $displayName" -ForegroundColor Gray

        # Check if ring already exists
        $uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations?`$filter=displayName eq '$displayName'"
        $existing = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue

        if ($existing.value -and $existing.value.Count -gt 0) {
            Write-Host "  [SKIP] Update ring already exists: $displayName" -ForegroundColor Yellow
            $createdRings[$displayName] = $existing.value[0].id
            continue
        }

        $ringBody = @{
            "@odata.type"                            = "#microsoft.graph.windowsUpdateForBusinessConfiguration"
            displayName                              = $displayName
            description                              = $ringDef.description
            qualityUpdatesDeferralPeriodInDays        = $ringDef.deferQualityUpdatesDays
            featureUpdatesDeferralPeriodInDays        = $ringDef.deferFeatureUpdatesDays
            automaticUpdateMode                      = "autoInstallAtMaintenanceTime"
            qualityUpdatesPauseExpiryDateTime         = "0001-01-01T00:00:00Z"
            featureUpdatesPauseExpiryDateTime         = "0001-01-01T00:00:00Z"
            businessReadyUpdatesOnly                 = "userDefined"
            deliveryOptimizationMode                 = "httpWithPeeringNat"
            microsoftUpdateServiceAllowed            = $true
            driversExcluded                          = $false
            installationSchedule                     = @{
                "@odata.type" = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                activeHoursStart = "08:00:00"
                activeHoursEnd   = "17:00:00"
            }
        }

        $result = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations" `
            -Body ($ringBody | ConvertTo-Json -Depth 10) `
            -ContentType "application/json"

        Write-Host "  [CREATED] $displayName (ID: $($result.id))" -ForegroundColor Green
        $createdRings[$displayName] = $result.id
    }

    Write-Host "[06-UpdateRings] Complete. $($createdRings.Count) rings processed.`n" -ForegroundColor Cyan
    return $createdRings
}

Export-ModuleMember -Function Deploy-W365UpdateRings
