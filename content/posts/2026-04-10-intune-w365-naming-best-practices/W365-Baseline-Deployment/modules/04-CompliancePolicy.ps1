<#
.SYNOPSIS
    Module 04 - Create Intune Compliance Policies for Windows 365.

.DESCRIPTION
    Creates Windows 10/11 compliance policies optimized for Cloud PCs.
    BitLocker is explicitly excluded per Windows 365 guidance.
    Policies are created without assignments — assign manually after review.

.NOTES
    Requires: Microsoft.Graph.DeviceManagement
#>

function Deploy-W365CompliancePolicies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [array]$PolicyDefinitions
    )

    Write-Host "`n[04-Compliance] Deploying compliance policies..." -ForegroundColor Cyan
    $createdPolicies = @{}

    foreach ($policyDef in $PolicyDefinitions) {
        $displayName = $policyDef.displayName
        Write-Host "  Checking: $displayName" -ForegroundColor Gray

        # Check if policy already exists
        $uri = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies?`$filter=displayName eq '$displayName'"
        $existing = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue

        if ($existing.value -and $existing.value.Count -gt 0) {
            Write-Host "  [SKIP] Policy already exists: $displayName" -ForegroundColor Yellow
            $createdPolicies[$displayName] = $existing.value[0].id
            continue
        }

        $settings = $policyDef.settings

        $policyBody = @{
            "@odata.type"                     = "#microsoft.graph.windows10CompliancePolicy"
            displayName                       = $displayName
            description                       = $policyDef.description
            passwordRequired                  = $settings.passwordRequired
            passwordMinimumLength             = $settings.passwordMinimumLength
            passwordRequiredType              = $settings.passwordRequiredType
            osMinimumVersion                  = $settings.osMinimumVersion
            firewallEnabled                   = $settings.firewallEnabled
            antivirusRequired                 = $settings.antivirusRequired
            defenderEnabled                   = $settings.defenderEnabled
            # BitLocker explicitly NOT set — not supported on Cloud PCs
            # bitLockerEnabled               = $false
        }

        $result = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies" `
            -Body ($policyBody | ConvertTo-Json -Depth 5) `
            -ContentType "application/json"

        Write-Host "  [CREATED] $displayName (ID: $($result.id))" -ForegroundColor Green
        $createdPolicies[$displayName] = $result.id
    }

    Write-Host "[04-Compliance] Complete. $($createdPolicies.Count) policies processed.`n" -ForegroundColor Cyan
    return $createdPolicies
}

Export-ModuleMember -Function Deploy-W365CompliancePolicies
