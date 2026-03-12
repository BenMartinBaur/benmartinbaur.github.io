<#
.SYNOPSIS
    Module 01 - Connect to Microsoft Graph with the required scopes.

.DESCRIPTION
    Authenticates to Microsoft Graph using interactive or app-based auth.
    Required scopes are requested for group, policy, and CA management.

.NOTES
    Requires: Microsoft.Graph PowerShell SDK
    Install:  Install-Module Microsoft.Graph -Scope CurrentUser
#>

function Connect-W365Baseline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$TenantId,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Interactive", "DeviceCode")]
        [string]$AuthMethod = "Interactive"
    )

    $requiredScopes = @(
        "Group.ReadWrite.All",
        "DeviceManagementConfiguration.ReadWrite.All",
        "DeviceManagementManagedDevices.ReadWrite.All",
        "Policy.ReadWrite.ConditionalAccess",
        "Policy.Read.All",
        "Directory.ReadWrite.All"
    )

    Write-Host "[01-Connect] Connecting to Microsoft Graph..." -ForegroundColor Cyan

    $connectParams = @{
        Scopes = $requiredScopes
    }

    if ($TenantId) {
        $connectParams.TenantId = $TenantId
    }

    if ($AuthMethod -eq "DeviceCode") {
        $connectParams.UseDeviceCode = $true
    }

    Connect-MgGraph @connectParams

    $context = Get-MgContext
    if (-not $context) {
        throw "[01-Connect] Failed to connect to Microsoft Graph."
    }

    Write-Host "[01-Connect] Connected as: $($context.Account) | Tenant: $($context.TenantId)" -ForegroundColor Green
    return $context
}

Export-ModuleMember -Function Connect-W365Baseline
