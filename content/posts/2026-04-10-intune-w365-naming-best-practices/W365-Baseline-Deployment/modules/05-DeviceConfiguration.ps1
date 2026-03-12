<#
.SYNOPSIS
    Module 05 - Create Intune Device Configuration Profiles for Windows 365.

.DESCRIPTION
    Creates custom OMA-URI device configuration profiles.
    Profiles are created without assignments — assign manually after review.

.NOTES
    Requires: Microsoft.Graph.DeviceManagement
#>

function Deploy-W365DeviceConfigurations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [array]$ConfigDefinitions
    )

    Write-Host "`n[05-DeviceConfig] Deploying device configuration profiles..." -ForegroundColor Cyan
    $createdConfigs = @{}

    foreach ($configDef in $ConfigDefinitions) {
        $displayName = $configDef.displayName
        Write-Host "  Checking: $displayName" -ForegroundColor Gray

        # Check if profile already exists
        $uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations?`$filter=displayName eq '$displayName'"
        $existing = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue

        if ($existing.value -and $existing.value.Count -gt 0) {
            Write-Host "  [SKIP] Profile already exists: $displayName" -ForegroundColor Yellow
            $createdConfigs[$displayName] = $existing.value[0].id
            continue
        }

        # Build OMA-URI settings
        $omaSettings = @()
        foreach ($oma in $configDef.omaSettings) {
            $omaSettings += @{
                "@odata.type" = "#microsoft.graph.omaSettingInteger"
                displayName   = $oma.displayName
                omaUri        = $oma.omaUri
                value         = $oma.value
            }
        }

        $configBody = @{
            "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
            displayName   = $displayName
            description   = $configDef.description
            omaSettings   = $omaSettings
        }

        $result = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations" `
            -Body ($configBody | ConvertTo-Json -Depth 10) `
            -ContentType "application/json"

        Write-Host "  [CREATED] $displayName (ID: $($result.id))" -ForegroundColor Green
        $createdConfigs[$displayName] = $result.id
    }

    Write-Host "[05-DeviceConfig] Complete. $($createdConfigs.Count) profiles processed.`n" -ForegroundColor Cyan
    return $createdConfigs
}

Export-ModuleMember -Function Deploy-W365DeviceConfigurations
