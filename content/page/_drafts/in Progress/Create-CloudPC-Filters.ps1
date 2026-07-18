<#
.SYNOPSIS
    Erstellt Intune Assignment-Filter für Windows 365 Cloud PCs.

.DESCRIPTION
    Dieses Skript erstellt automatisch folgende Filter im Microsoft Intune Admin Center:
    1. Einen Filter für ALLE Cloud PCs
    2. Einen Filter pro Provisioning Policy
    3. Einen Filter pro verfügbarem Cloud PC SKU (Konfiguration)

.NOTES
    Tenant: xxxx.xxxx.xxxx
    Benötigt: Microsoft.Graph PowerShell Module
    Datum: 27.02.2026
#>

# Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement

param(
    [string]$TenantId = ""
)

# ============================================================
# Region: Hilfsfunktionen
# ============================================================

function Write-Step {
    param([string]$Message)
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "  [i]  $Message" -ForegroundColor Yellow
}

function Write-Fail {
    param([string]$Message)
    Write-Host "  [X]  $Message" -ForegroundColor Red
}

function New-IntuneFilter {
    <#
    .SYNOPSIS
        Erstellt einen Intune Assignment-Filter via Microsoft Graph API.
    #>
    param(
        [string]$DisplayName,
        [string]$Description,
        [string]$Rule,
        [string]$Platform = "windows10AndLater"
    )

    $uri = "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters"

    $body = @{
        displayName = $DisplayName
        description = $Description
        platform    = $Platform
        rule        = $Rule
        roleScopeTags = @("0")
    } | ConvertTo-Json -Depth 5

    try {
        $response = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $body -ContentType "application/json"
        Write-Success "Filter erstellt: '$DisplayName' (ID: $($response.id))"
        return $response
    }
    catch {
        if ($_.Exception.Message -like "*already exists*" -or $_.Exception.Message -like "*Conflict*") {
            Write-Info "Filter '$DisplayName' existiert bereits - wird uebersprungen."
        }
        else {
            Write-Fail "Fehler beim Erstellen von '$DisplayName': $($_.Exception.Message)"
        }
        return $null
    }
}

# ============================================================
# Region: Modul-Check & Installation
# ============================================================

Write-Step "Pruefe Microsoft Graph PowerShell Module..."

$requiredModules = @(
    "Microsoft.Graph.Authentication"
)

foreach ($mod in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $mod)) {
        Write-Info "Installiere Modul '$mod'..."
        Install-Module -Name $mod -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module $mod -ErrorAction Stop
    Write-Success "Modul '$mod' geladen."
}

# ============================================================
# Region: Verbindung zu Microsoft Graph
# ============================================================

Write-Step "Verbinde mit Microsoft Graph (Tenant: $TenantId)..."

# Benötigte Berechtigungen:
#   - DeviceManagementConfiguration.ReadWrite.All   (Filter erstellen)
#   - DeviceManagementManagedDevices.Read.All        (Cloud PCs lesen)
#   - CloudPC.Read.All                               (Provisioning Policies & SKUs lesen)

$scopes = @(
    "DeviceManagementConfiguration.ReadWrite.All",
    "DeviceManagementManagedDevices.Read.All",
    "CloudPC.Read.All"
)

try {
    Connect-MgGraph -TenantId $TenantId -Scopes $scopes -ErrorAction Stop
    $context = Get-MgContext
    Write-Success "Verbunden als: $($context.Account) | Tenant: $($context.TenantId)"
}
catch {
    Write-Fail "Verbindung fehlgeschlagen: $($_.Exception.Message)"
    Write-Host "`n  Tipp: Stellen Sie sicher, dass Sie die richtige Berechtigung haben." -ForegroundColor Yellow
    exit 1
}

# ============================================================
# Region: Bestehende Filter abrufen
# ============================================================

Write-Step "Rufe bestehende Intune-Filter ab..."

try {
    $existingFiltersResponse = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters" 
    $existingFilters = $existingFiltersResponse.value
    Write-Info "Aktuell $($existingFilters.Count) Filter vorhanden."
    foreach ($f in $existingFilters) {
        Write-Host "       - $($f.displayName)" -ForegroundColor DarkGray
    }
}
catch {
    Write-Info "Konnte bestehende Filter nicht abrufen: $($_.Exception.Message)"
    $existingFilters = @()
}

# ============================================================
# Region 1: Filter fuer ALLE Cloud PCs
# ============================================================

Write-Step "1/3 - Erstelle Filter fuer ALLE Cloud PCs..."

$filterName = "Alle Cloud PCs"
if ($existingFilters | Where-Object { $_.displayName -eq $filterName }) {
    Write-Info "Filter '$filterName' existiert bereits - wird uebersprungen."
}
else {
    New-IntuneFilter `
        -DisplayName $filterName `
        -Description "Filter der alle Windows 365 Cloud PC Geraete enthaelt (Model contains Cloud PC)" `
        -Rule '(device.model -contains "Cloud PC")'
}

# ============================================================
# Region 2: Filter pro Provisioning Policy
# ============================================================

Write-Step "2/3 - Rufe alle Provisioning Policies ab und erstelle Filter..."

try {
    $policiesResponse = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/virtualEndpoint/provisioningPolicies"
    $policies = $policiesResponse.value

    if ($policies.Count -eq 0) {
        Write-Info "Keine Provisioning Policies gefunden."
    }
    else {
        Write-Info "$($policies.Count) Provisioning Policies gefunden:`n"
        
        foreach ($policy in $policies) {
            $policyName = $policy.displayName
            $filterDisplayName = "Cloud PCs - Provisioning Policy: $policyName"

            Write-Host "       Policy: '$policyName' (ID: $($policy.id))" -ForegroundColor DarkGray

            if ($existingFilters | Where-Object { $_.displayName -eq $filterDisplayName }) {
                Write-Info "Filter '$filterDisplayName' existiert bereits - wird uebersprungen."
                continue
            }

            # Filter-Regel: enrollmentProfileName equals <PolicyName> AND model contains Cloud PC
            $rule = '(device.enrollmentProfileName -eq "' + $policyName + '") and (device.model -contains "Cloud PC")'

            New-IntuneFilter `
                -DisplayName $filterDisplayName `
                -Description "Filter fuer alle Cloud PCs aus der Provisioning Policy '$policyName'" `
                -Rule $rule
        }
    }
}
catch {
    Write-Fail "Fehler beim Abrufen der Provisioning Policies: $($_.Exception.Message)"
}

# ============================================================
# Region 3: Filter pro Cloud PC SKU
# ============================================================

Write-Step "3/3 - Rufe alle verfuegbaren Cloud PC SKUs ab und erstelle Filter..."

try {
    $skusResponse = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/virtualEndpoint/servicePlans"
    $skus = $skusResponse.value

    if ($skus.Count -eq 0) {
        Write-Info "Keine Cloud PC SKUs/Service Plans gefunden."
    }
    else {
        Write-Info "$($skus.Count) Cloud PC SKUs/Service Plans gefunden:`n"

        # Gruppiere nach vCPU/RAM-Konfigurationen, um deduplizierte Filter zu erstellen
        $configurations = @{}

        foreach ($sku in $skus) {
            $skuName      = $sku.displayName
            $vCpu         = $sku.vCpuCount
            $ramInGB      = $sku.ramInGB
            $storageInGB  = $sku.storageInGB
            $type         = $sku.type  # enterprise, frontline, etc.

            Write-Host "       SKU: $skuName | vCPU: $vCpu | RAM: ${ramInGB}GB | Storage: ${storageInGB}GB | Typ: $type" -ForegroundColor DarkGray

            # Erstelle einen eindeutigen Key pro Konfiguration
            $configKey = "${vCpu}vCPU/${ramInGB}GB/${storageInGB}GB"
            
            if (-not $configurations.ContainsKey($configKey)) {
                $configurations[$configKey] = @{
                    vCpu       = $vCpu
                    RamInGB    = $ramInGB
                    StorageInGB = $storageInGB
                    DisplayName = $skuName
                    Type       = $type
                }
            }
        }

        Write-Host ""
        Write-Info "$($configurations.Count) eindeutige Konfigurationen gefunden.`n"

        foreach ($configKey in $configurations.Keys) {
            $config = $configurations[$configKey]
            $filterDisplayName = "Cloud PCs - SKU: $configKey"

            if ($existingFilters | Where-Object { $_.displayName -eq $filterDisplayName }) {
                Write-Info "Filter '$filterDisplayName' existiert bereits - wird uebersprungen."
                continue
            }

            # Filter-Regel basiert auf dem Model-Property das vCPU/RAM enthält
            # Cloud PC Model-Format: "Cloud PC Enterprise 2vCPU/4GB/128GB" oder ähnlich
            $modelSearchValue = "$($config.vCpu)vCPU/$($config.RamInGB)GB"
            $rule = '(device.model -contains "' + $modelSearchValue + '") and (device.model -contains "Cloud PC")'

            New-IntuneFilter `
                -DisplayName $filterDisplayName `
                -Description "Filter fuer alle Cloud PCs mit der Konfiguration $configKey ($($config.DisplayName))" `
                -Rule $rule
        }
    }
}
catch {
    Write-Fail "Fehler beim Abrufen der Cloud PC SKUs: $($_.Exception.Message)"

    # Fallback: Erstelle Filter fuer gaengige Konfigurationen
    Write-Info "Erstelle Filter fuer gaengige Cloud PC Konfigurationen als Fallback..."

    $commonConfigs = @(
        @{ Name = "2vCPU/4GB";    Desc = "2 vCPU, 4 GB RAM" },
        @{ Name = "2vCPU/8GB";    Desc = "2 vCPU, 8 GB RAM" },
        @{ Name = "4vCPU/16GB";   Desc = "4 vCPU, 16 GB RAM" },
        @{ Name = "8vCPU/32GB";   Desc = "8 vCPU, 32 GB RAM" },
        @{ Name = "16vCPU/64GB";  Desc = "16 vCPU, 64 GB RAM" }
    )

    foreach ($cfg in $commonConfigs) {
        $filterDisplayName = "Cloud PCs - SKU: $($cfg.Name)"

        if ($existingFilters | Where-Object { $_.displayName -eq $filterDisplayName }) {
            Write-Info "Filter '$filterDisplayName' existiert bereits - wird uebersprungen."
            continue
        }

        $rule = '(device.model -contains "' + $cfg.Name + '") and (device.model -contains "Cloud PC")'

        New-IntuneFilter `
            -DisplayName $filterDisplayName `
            -Description "Filter fuer alle Cloud PCs mit $($cfg.Desc)" `
            -Rule $rule
    }
}

# ============================================================
# Region: Zusammenfassung
# ============================================================

Write-Step "Zusammenfassung - Alle aktuellen Filter:"

try {
    $allFiltersResponse = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters"
    $allFilters = $allFiltersResponse.value | Where-Object { $_.displayName -like "*Cloud PC*" }

    Write-Host ""
    $allFilters | ForEach-Object {
        Write-Host "  Name:     $($_.displayName)" -ForegroundColor White
        Write-Host "  Regel:    $($_.rule)" -ForegroundColor DarkGray
        Write-Host "  Plattform: $($_.platform)" -ForegroundColor DarkGray
        Write-Host "  ID:       $($_.id)" -ForegroundColor DarkGray
        Write-Host ""
    }

    Write-Success "Insgesamt $($allFilters.Count) Cloud PC Filter vorhanden."
}
catch {
    Write-Fail "Konnte finale Filterliste nicht abrufen."
}

Write-Host "`n" 
Write-Host "  Fertig! Die Filter koennen jetzt im Intune Admin Center verwendet werden:" -ForegroundColor Green
Write-Host "  https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/assignmentFilters" -ForegroundColor Cyan
Write-Host "`n"

# Verbindung trennen
Disconnect-MgGraph | Out-Null
Write-Info "Microsoft Graph Verbindung getrennt."
