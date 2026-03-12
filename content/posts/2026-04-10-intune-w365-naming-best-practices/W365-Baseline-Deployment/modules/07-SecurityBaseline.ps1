<#
.SYNOPSIS
    Module 07 - Guidance for deploying Windows 365 Security Baseline.

.DESCRIPTION
    The Windows 365 Security Baseline (24H1) must be deployed via the
    Intune admin center UI (Endpoint Security > Security Baselines).
    It cannot be fully created via Graph API due to the complex
    settings catalog structure.

    This module provides a check to see if a baseline profile exists
    and outputs guidance for manual deployment.

.NOTES
    Requires: Microsoft.Graph.DeviceManagement
#>

function Deploy-W365SecurityBaseline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$BaselineName = "SBL-W365-24H1"
    )

    Write-Host "`n[07-SecurityBaseline] Checking Windows 365 Security Baseline..." -ForegroundColor Cyan

    # Check if any security baseline templates are available
    $uri = "https://graph.microsoft.com/beta/deviceManagement/templates?`$filter=templateType eq 'securityBaseline'"
    $templates = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue

    $w365Template = $templates.value | Where-Object { $_.displayName -like "*Windows 365*" -or $_.displayName -like "*Cloud PC*" }

    if ($w365Template) {
        Write-Host "  [INFO] Windows 365 Security Baseline template found:" -ForegroundColor Green
        foreach ($t in $w365Template) {
            Write-Host "         - $($t.displayName) (Version: $($t.versionInfo))" -ForegroundColor Green
        }
    }
    else {
        Write-Host "  [INFO] No Windows 365 Security Baseline template found in tenant." -ForegroundColor Yellow
    }

    Write-Host @"

  ┌──────────────────────────────────────────────────────────────────┐
  │  MANUAL STEP REQUIRED                                           │
  │                                                                 │
  │  Deploy the Windows 365 Security Baseline (24H1) via the        │
  │  Intune admin center:                                           │
  │                                                                 │
  │  1. Go to Endpoint Security > Security Baselines                │
  │  2. Select 'Windows 365 Security Baseline Version 24H1'         │
  │  3. Create Profile > Name it: $BaselineName                     │
  │  4. Review default settings (modify as needed)                  │
  │  5. Assign to your Cloud PC device group                        │
  │                                                                 │
  │  The baseline covers:                                           │
  │  - Windows 11/10 hardening                                      │
  │  - Microsoft Edge security settings                             │
  │  - Microsoft Defender for Endpoint configuration                │
  │                                                                 │
  │  TIP: Test on pilot group first (GRP-IT-W365-Pilot)             │
  └──────────────────────────────────────────────────────────────────┘
"@ -ForegroundColor Magenta

    Write-Host "[07-SecurityBaseline] Complete.`n" -ForegroundColor Cyan
}

Export-ModuleMember -Function Deploy-W365SecurityBaseline
