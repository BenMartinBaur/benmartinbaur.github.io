<#
.SYNOPSIS
    Windows 365 Baseline Deployment Orchestrator

.DESCRIPTION
    Deploys a complete Windows 365 baseline configuration to Microsoft Intune
    using Microsoft Graph. Each module can be run independently or orchestrated
    together via this script.

    All policies are created WITHOUT assignments and Conditional Access policies
    are in REPORT-ONLY mode. Review and assign manually after validation.

.PARAMETER ConfigPath
    Path to the baseline-config.json configuration file.
    Default: .\config\baseline-config.json

.PARAMETER ModulesOnly
    Comma-separated list of module numbers to run (e.g., "02,04,06").
    Default: runs all modules.

.PARAMETER WhatIf
    Shows what would be deployed without making changes.

.EXAMPLE
    # Deploy everything
    .\Deploy-W365Baseline.ps1

    # Deploy only groups and compliance policies
    .\Deploy-W365Baseline.ps1 -ModulesOnly "02,04"

    # Preview what would be deployed
    .\Deploy-W365Baseline.ps1 -WhatIf

.NOTES
    Prerequisites:
      - PowerShell 7+
      - Microsoft.Graph PowerShell SDK
        Install-Module Microsoft.Graph -Scope CurrentUser
      - Sufficient permissions (Global Admin or scoped roles)

    Author: Ben Martin Baur
    Version: 1.0
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config\baseline-config.json"),

    [Parameter(Mandatory = $false)]
    [string]$ModulesOnly = ""
)

# ── Banner ──────────────────────────────────────────────────────────────
Write-Host @"

╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║   Windows 365 Baseline Deployment                                    ║
║   ─────────────────────────────────                                  ║
║   Modular Intune + Windows 365 policy deployment via Graph API       ║
║                                                                      ║
║   Modules:                                                           ║
║     01 - Connect to Microsoft Graph                                  ║
║     02 - Entra ID Security Groups                                    ║
║     03 - Assignment Filters                                          ║
║     04 - Compliance Policies                                         ║
║     05 - Device Configuration Profiles                               ║
║     06 - Windows Update Rings                                        ║
║     07 - Security Baseline (guidance)                                ║
║     08 - Conditional Access Policies                                 ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# ── Determine which modules to run ──────────────────────────────────────
$allModules = @("01", "02", "03", "04", "05", "06", "07", "08")

if ($ModulesOnly) {
    $selectedModules = $ModulesOnly -split "," | ForEach-Object { $_.Trim().PadLeft(2, '0') }
    # Always include 01 (Connect) if any other module is selected
    if ($selectedModules -notcontains "01") {
        $selectedModules = @("01") + $selectedModules
    }
}
else {
    $selectedModules = $allModules
}

Write-Host "Selected modules: $($selectedModules -join ', ')" -ForegroundColor Gray

# ── Load Configuration ──────────────────────────────────────────────────
if (-not (Test-Path $ConfigPath)) {
    throw "Configuration file not found: $ConfigPath"
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
Write-Host "Configuration loaded from: $ConfigPath" -ForegroundColor Gray

if ($WhatIfPreference) {
    Write-Host "`n[WHATIF MODE] No changes will be made.`n" -ForegroundColor Yellow
    Write-Host "Would deploy:"
    if ($selectedModules -contains "02") {
        Write-Host "  Groups: $($config.groups.Count) group(s)" -ForegroundColor Gray
        $config.groups | ForEach-Object { Write-Host "    - $($_.displayName)" }
    }
    if ($selectedModules -contains "03") {
        Write-Host "  Filters: $($config.assignmentFilters.Count) filter(s)" -ForegroundColor Gray
        $config.assignmentFilters | ForEach-Object { Write-Host "    - $($_.displayName)" }
    }
    if ($selectedModules -contains "04") {
        Write-Host "  Compliance: $($config.compliancePolicies.Count) policy(s)" -ForegroundColor Gray
        $config.compliancePolicies | ForEach-Object { Write-Host "    - $($_.displayName)" }
    }
    if ($selectedModules -contains "05") {
        Write-Host "  Device Config: $($config.deviceConfigurations.Count) profile(s)" -ForegroundColor Gray
        $config.deviceConfigurations | ForEach-Object { Write-Host "    - $($_.displayName)" }
    }
    if ($selectedModules -contains "06") {
        Write-Host "  Update Rings: $($config.updateRings.Count) ring(s)" -ForegroundColor Gray
        $config.updateRings | ForEach-Object { Write-Host "    - $($_.displayName)" }
    }
    if ($selectedModules -contains "07") {
        Write-Host "  Security Baseline: Manual deployment guidance" -ForegroundColor Gray
    }
    if ($selectedModules -contains "08") {
        Write-Host "  Conditional Access: $($config.conditionalAccessPolicies.Count) policy(s) (report-only)" -ForegroundColor Gray
        $config.conditionalAccessPolicies | ForEach-Object { Write-Host "    - $($_.displayName)" }
    }
    return
}

# ── Source modules ──────────────────────────────────────────────────────
$modulesPath = Join-Path $PSScriptRoot "modules"
foreach ($mod in $selectedModules) {
    $moduleFiles = Get-ChildItem -Path $modulesPath -Filter "$mod-*.ps1"
    foreach ($file in $moduleFiles) {
        Write-Host "Loading module: $($file.Name)" -ForegroundColor DarkGray
        . $file.FullName
    }
}

# ── Execute modules ────────────────────────────────────────────────────
$results = @{}

# 01 - Connect
if ($selectedModules -contains "01") {
    $context = Connect-W365Baseline -TenantId $config.tenantId
    $results["Connection"] = $context
}

# 02 - Groups
$groupLookup = @{}
if ($selectedModules -contains "02") {
    $groupLookup = Deploy-W365Groups -GroupDefinitions $config.groups
    $results["Groups"] = $groupLookup
}

# 03 - Assignment Filters
if ($selectedModules -contains "03") {
    $filterLookup = Deploy-W365AssignmentFilters -FilterDefinitions $config.assignmentFilters
    $results["Filters"] = $filterLookup
}

# 04 - Compliance Policies
if ($selectedModules -contains "04") {
    $complianceLookup = Deploy-W365CompliancePolicies -PolicyDefinitions $config.compliancePolicies
    $results["Compliance"] = $complianceLookup
}

# 05 - Device Configuration
if ($selectedModules -contains "05") {
    $configLookup = Deploy-W365DeviceConfigurations -ConfigDefinitions $config.deviceConfigurations
    $results["DeviceConfig"] = $configLookup
}

# 06 - Update Rings
if ($selectedModules -contains "06") {
    $ringLookup = Deploy-W365UpdateRings -RingDefinitions $config.updateRings
    $results["UpdateRings"] = $ringLookup
}

# 07 - Security Baseline
if ($selectedModules -contains "07") {
    Deploy-W365SecurityBaseline
}

# 08 - Conditional Access
if ($selectedModules -contains "08") {
    # If groups weren't created in this run, try to look them up
    if ($groupLookup.Count -eq 0) {
        Write-Host "  Looking up existing groups for CA policy assignment..." -ForegroundColor Gray
        foreach ($caPol in $config.conditionalAccessPolicies) {
            if ($caPol.includeGroups) {
                $grp = Get-MgGroup -Filter "displayName eq '$($caPol.includeGroups)'" -ErrorAction SilentlyContinue |
                    Select-Object -First 1
                if ($grp) {
                    $groupLookup[$caPol.includeGroups] = $grp.Id
                }
            }
        }
    }
    $caLookup = Deploy-W365ConditionalAccess -PolicyDefinitions $config.conditionalAccessPolicies -GroupLookup $groupLookup
    $results["ConditionalAccess"] = $caLookup
}

# ── Summary ─────────────────────────────────────────────────────────────
Write-Host @"

╔══════════════════════════════════════════════════════════════════════╗
║  DEPLOYMENT SUMMARY                                                  ║
╚══════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

foreach ($key in $results.Keys) {
    if ($results[$key] -is [hashtable]) {
        Write-Host "  $key : $($results[$key].Count) item(s)" -ForegroundColor White
    }
    else {
        Write-Host "  $key : OK" -ForegroundColor White
    }
}

Write-Host @"

  NEXT STEPS:
  1. Review all created policies in the Intune admin center
  2. Assign policies to the appropriate groups
  3. Deploy the Security Baseline manually (Module 07 guidance)
  4. Switch CA policies from report-only to enabled after validation
  5. Monitor with Endpoint Analytics and CA Insights

"@ -ForegroundColor Yellow
