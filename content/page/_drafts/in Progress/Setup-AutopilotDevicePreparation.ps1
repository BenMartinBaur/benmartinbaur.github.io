#Requires -Version 5.1
<#
.SYNOPSIS
    Sets up Windows Autopilot Device Preparation prerequisites for Windows 365 automatic mode.

.DESCRIPTION
    This script automates the following:
    1. Installs/imports required Microsoft Graph PowerShell modules
    2. Connects to Microsoft Graph with appropriate scopes
    3. Creates the Intune Provisioning Client service principal (if missing)
    4. Creates an assigned security device group for Autopilot Device Preparation
    5. Sets the Intune Provisioning Client as the group owner
    6. Verifies MDM enrollment configuration

.NOTES
    Author:     AVD Punks
    Date:       2026-02-27
    Requires:   PowerShell 5.1+, Global Admin or Intune Admin + Application Admin rights
    Reference:  https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-workflow
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$DeviceGroupName = "dg-w365-devicegroup-githubcli",

    [Parameter()]
    [string]$DeviceGroupDescription = "Assigned device group for Windows Autopilot Device Preparation - Windows 365 automatic mode",

    [Parameter()]
    [switch]$SkipModuleInstall
)

# ============================================================
# Configuration
# ============================================================
$IntuneProvisioningClientAppId = "f1346770-5b25-470b-88bd-d5744ab7952c"

$RequiredScopes = @(
    "Application.ReadWrite.All",
    "Group.ReadWrite.All",
    "DeviceManagementConfiguration.Read.All",
    "DeviceManagementServiceConfig.Read.All"
)

$RequiredModules = @(
    "Microsoft.Graph.Authentication",
    "Microsoft.Graph.Applications",
    "Microsoft.Graph.Groups"
)

# ============================================================
# Helper Functions
# ============================================================
function Write-Step {
    param([string]$StepNumber, [string]$Message)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  Step $StepNumber: $Message" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "  ✓ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "  ℹ $Message" -ForegroundColor Yellow
}

function Write-Fail {
    param([string]$Message)
    Write-Host "  ✗ $Message" -ForegroundColor Red
}

# ============================================================
# Step 1: Install & Import Required Modules
# ============================================================
Write-Step "1/5" "Installing and importing required Microsoft Graph modules"

if (-not $SkipModuleInstall) {
    foreach ($mod in $RequiredModules) {
        Write-Host "  Installing $mod..." -NoNewline
        try {
            Install-Module -Name $mod -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
            Write-Host " Done" -ForegroundColor Green
        } catch {
            Write-Host " Warning: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
} else {
    Write-Info "Module installation skipped (-SkipModuleInstall)"
}

foreach ($mod in $RequiredModules) {
    Write-Host "  Importing $mod..." -NoNewline
    try {
        Import-Module -Name $mod -Force -ErrorAction Stop
        Write-Host " Done" -ForegroundColor Green
    } catch {
        Write-Fail "Failed to import $mod. Error: $($_.Exception.Message)"
        exit 1
    }
}

Write-Success "All modules loaded"

# ============================================================
# Step 2: Connect to Microsoft Graph
# ============================================================
Write-Step "2/5" "Connecting to Microsoft Graph"

# Disconnect any stale sessions
Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null

$scopeString = $RequiredScopes -join ", "
Write-Info "Requesting scopes: $scopeString"
Write-Info "A browser window will open for authentication."
Write-Info "Sign in with a Global Admin or Intune Admin account."
Write-Host ""

try {
    Connect-MgGraph -Scopes $RequiredScopes -ErrorAction Stop
    $context = Get-MgContext
    Write-Success "Connected as: $($context.Account)"
    Write-Success "Tenant ID:    $($context.TenantId)"
} catch {
    Write-Fail "Failed to connect to Microsoft Graph: $($_.Exception.Message)"
    exit 1
}

# ============================================================
# Step 3: Create/Verify Intune Provisioning Client Service Principal
# ============================================================
Write-Step "3/5" "Creating Intune Provisioning Client service principal"

$servicePrincipal = $null
try {
    $servicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$IntuneProvisioningClientAppId'" -ErrorAction Stop
} catch {
    # Ignore - will create below
}

if ($servicePrincipal) {
    Write-Info "Service principal already exists in this tenant"
    Write-Success "Display Name: $($servicePrincipal.DisplayName)"
    Write-Success "Object ID:    $($servicePrincipal.Id)"
    Write-Success "App ID:       $($servicePrincipal.AppId)"
} else {
    Write-Info "Service principal not found — creating it now..."
    try {
        $servicePrincipal = New-MgServicePrincipal -AppId $IntuneProvisioningClientAppId -ErrorAction Stop
        Write-Success "Service principal created successfully!"
        Write-Success "Display Name: $($servicePrincipal.DisplayName)"
        Write-Success "Object ID:    $($servicePrincipal.Id)"
        Write-Success "App ID:       $($servicePrincipal.AppId)"
    } catch {
        Write-Fail "Failed to create service principal: $($_.Exception.Message)"
        if ($_.Exception.InnerException) {
            Write-Fail "Inner error: $($_.Exception.InnerException.Message)"
        }
        Write-Info "You may need Global Admin or Application Admin permissions."
        exit 1
    }
}

# ============================================================
# Step 4: Create Assigned Device Security Group
# ============================================================
Write-Step "4/5" "Creating assigned device security group"

# Check if group already exists
$existingGroup = $null
try {
    $existingGroup = Get-MgGroup -Filter "displayName eq '$DeviceGroupName'" -ErrorAction Stop
} catch {
    # Ignore
}

if ($existingGroup) {
    Write-Info "Group '$DeviceGroupName' already exists"
    Write-Success "Group ID: $($existingGroup.Id)"

    # Verify the Intune Provisioning Client is an owner
    Write-Host "  Checking group owners..." -NoNewline
    $owners = Get-MgGroupOwner -GroupId $existingGroup.Id -ErrorAction SilentlyContinue
    $isOwner = $owners | Where-Object { $_.Id -eq $servicePrincipal.Id }

    if ($isOwner) {
        Write-Host " Intune Provisioning Client is already an owner" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Info "Adding Intune Provisioning Client as group owner..."
        try {
            $ownerRef = @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/servicePrincipals/$($servicePrincipal.Id)"
            }
            New-MgGroupOwnerByRef -GroupId $existingGroup.Id -BodyParameter $ownerRef -ErrorAction Stop
            Write-Success "Intune Provisioning Client added as group owner"
        } catch {
            if ($_.Exception.Message -match "already exist") {
                Write-Info "Owner reference already exists (different check path)"
            } else {
                Write-Fail "Failed to add owner: $($_.Exception.Message)"
            }
        }
    }

    $deviceGroup = $existingGroup
} else {
    Write-Info "Creating group: $DeviceGroupName"

    try {
        # Create the group
        $groupParams = @{
            DisplayName     = $DeviceGroupName
            Description     = $DeviceGroupDescription
            GroupTypes      = @()                # No group types = assigned (not dynamic)
            SecurityEnabled = $true
            MailEnabled     = $false
            MailNickname    = ($DeviceGroupName -replace '[^a-zA-Z0-9]', '')
            IsAssignableToRole = $false
        }

        $deviceGroup = New-MgGroup -BodyParameter $groupParams -ErrorAction Stop
        Write-Success "Group created successfully!"
        Write-Success "Display Name: $($deviceGroup.DisplayName)"
        Write-Success "Group ID:     $($deviceGroup.Id)"

        # Add Intune Provisioning Client as owner
        Write-Info "Adding Intune Provisioning Client as group owner..."
        Start-Sleep -Seconds 3  # Brief wait for group replication

        $ownerRef = @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/servicePrincipals/$($servicePrincipal.Id)"
        }
        New-MgGroupOwnerByRef -GroupId $deviceGroup.Id -BodyParameter $ownerRef -ErrorAction Stop
        Write-Success "Intune Provisioning Client set as group owner"

    } catch {
        Write-Fail "Failed to create group: $($_.Exception.Message)"
        if ($_.Exception.InnerException) {
            Write-Fail "Inner error: $($_.Exception.InnerException.Message)"
        }
        exit 1
    }
}

# ============================================================
# Step 5: Verify MDM Enrollment Configuration
# ============================================================
Write-Step "5/5" "Verification summary"

Write-Host ""
Write-Host "  ┌──────────────────────────────────────────────────────┐" -ForegroundColor White
Write-Host "  │  AUTOPILOT DEVICE PREPARATION - SETUP SUMMARY       │" -ForegroundColor White
Write-Host "  ├──────────────────────────────────────────────────────┤" -ForegroundColor White
Write-Host "  │  Tenant:              $($context.TenantId)" -ForegroundColor White
Write-Host "  │  Account:             $($context.Account)" -ForegroundColor White
Write-Host "  │" -ForegroundColor White
Write-Host "  │  Service Principal:   $($servicePrincipal.DisplayName)" -ForegroundColor Green
Write-Host "  │  SP App ID:           $($servicePrincipal.AppId)" -ForegroundColor Green
Write-Host "  │  SP Object ID:        $($servicePrincipal.Id)" -ForegroundColor Green
Write-Host "  │" -ForegroundColor White
Write-Host "  │  Device Group:        $($deviceGroup.DisplayName)" -ForegroundColor Green
Write-Host "  │  Group ID:            $($deviceGroup.Id)" -ForegroundColor Green
Write-Host "  │  Group Type:          Assigned Security Group" -ForegroundColor Green
Write-Host "  │  Group Owner:         $($servicePrincipal.DisplayName)" -ForegroundColor Green
Write-Host "  └──────────────────────────────────────────────────────┘" -ForegroundColor White
Write-Host ""

Write-Host "  Next Steps:" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  1. Verify MDM enrollment: Azure Portal > Entra ID > Mobility (MDM and WIP)" -ForegroundColor White
Write-Host "     MDM User scope must be set to 'All' or 'Some'" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  2. Assign apps to device group: Intune > Apps > Windows > [App] > " -ForegroundColor White
Write-Host "     Properties > Assignments > Required > Add group: '$DeviceGroupName'" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  3. Assign scripts to device group: Intune > Devices > Scripts and" -ForegroundColor White
Write-Host "     remediations > Platform scripts > [Script] > Properties > Assignments" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  4. Create Autopilot Device Preparation policy: Intune > Devices > Windows" -ForegroundColor White
Write-Host "     > Enrollment > Device preparation policies > Create > Automatic (Preview)" -ForegroundColor DarkGray
Write-Host "     Select device group: '$DeviceGroupName'" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  5. Create Cloud PC provisioning policy: Intune > Devices > Windows 365 >" -ForegroundColor White
Write-Host "     Provisioning policies > Create policy" -ForegroundColor DarkGray
Write-Host "     Link the Autopilot Device Preparation policy under Configuration" -ForegroundColor DarkGray
Write-Host ""

# ============================================================
# Disconnect
# ============================================================
Write-Host "  Disconnecting from Microsoft Graph..." -NoNewline
Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
Write-Host " Done" -ForegroundColor Green
Write-Host ""
Write-Host "  Script completed successfully!" -ForegroundColor Green
Write-Host ""
