<#
.SYNOPSIS
    Module 08 - Create Conditional Access Policies for Windows 365.

.DESCRIPTION
    Creates Conditional Access policies targeting Cloud PC access.
    All policies are created in REPORT-ONLY mode by default for safety.
    Review and enable after validation.

.NOTES
    Requires: Microsoft.Graph.Identity.SignIns
    The Windows 365 app ID is: 0af06dc6-e4b5-4f28-818e-e78e62d137a5
#>

function Deploy-W365ConditionalAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [array]$PolicyDefinitions,

        [Parameter(Mandatory = $true)]
        [hashtable]$GroupLookup
    )

    Write-Host "`n[08-ConditionalAccess] Deploying Conditional Access policies (report-only)..." -ForegroundColor Cyan
    $createdPolicies = @{}

    foreach ($policyDef in $PolicyDefinitions) {
        $displayName = $policyDef.displayName
        Write-Host "  Checking: $displayName" -ForegroundColor Gray

        # Check if CA policy already exists
        $existing = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq '$displayName'" -ErrorAction SilentlyContinue |
            Select-Object -First 1

        if ($existing) {
            Write-Host "  [SKIP] CA policy already exists: $displayName (ID: $($existing.Id))" -ForegroundColor Yellow
            $createdPolicies[$displayName] = $existing.Id
            continue
        }

        # Resolve target group ID
        $targetGroupId = $null
        if ($policyDef.includeGroups -and $GroupLookup.ContainsKey($policyDef.includeGroups)) {
            $targetGroupId = $GroupLookup[$policyDef.includeGroups]
        }

        # Build grant controls
        $builtInControls = @()
        foreach ($grant in $policyDef.grantControls) {
            switch ($grant) {
                "mfa" { $builtInControls += "mfa" }
                "compliantDevice" { $builtInControls += "compliantDevice" }
                "domainJoinedDevice" { $builtInControls += "domainJoinedDevice" }
            }
        }

        $caBody = @{
            displayName = $displayName
            state       = "enabledForReportingButNotEnforced"  # Always report-only
            conditions  = @{
                users        = @{
                    includeGroups = if ($targetGroupId) { @($targetGroupId) } else { @() }
                }
                applications = @{
                    includeApplications = $policyDef.includeApplications
                }
                clientAppTypes = @("browser", "mobileAppsAndDesktopClients")
            }
            grantControls = @{
                operator        = "OR"
                builtInControls = $builtInControls
            }
        }

        $result = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" `
            -Body ($caBody | ConvertTo-Json -Depth 10) `
            -ContentType "application/json"

        Write-Host "  [CREATED] $displayName (ID: $($result.id)) — REPORT-ONLY MODE" -ForegroundColor Green
        $createdPolicies[$displayName] = $result.id
    }

    Write-Host @"

  ┌──────────────────────────────────────────────────────────────────┐
  │  IMPORTANT: All CA policies are in REPORT-ONLY mode.            │
  │  Review the sign-in logs and Conditional Access insights         │
  │  before switching to 'Enabled'.                                  │
  └──────────────────────────────────────────────────────────────────┘
"@ -ForegroundColor Yellow

    Write-Host "[08-ConditionalAccess] Complete. $($createdPolicies.Count) policies processed.`n" -ForegroundColor Cyan
    return $createdPolicies
}

Export-ModuleMember -Function Deploy-W365ConditionalAccess
