<#
.SYNOPSIS
    Azure Outbound Access Audit & Remediation Tool for Azure Virtual Desktop.

.DESCRIPTION
    This tool audits Azure Virtual Networks for explicit outbound access configuration
    and provides remediation options including NAT Gateway deployment, new VNet creation,
    and AVD-ready NSG/ASG deployment.

    Context: Azure retires Default Outbound Access for new VNets after March 31, 2026.
    Session hosts in private subnets without explicit outbound will lose connectivity
    to AVD control plane, Windows activation, and agent update endpoints.

.NOTES
    Author:  Ben Baur - Principal Architect, Microsoft
    Version: 1.0.0
    Date:    2026-03-13
    Requires: Az.Network, Az.Accounts, Az.Resources modules (Az PowerShell 12.0+)

.LINK
    https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access
    https://learn.microsoft.com/en-us/azure/virtual-desktop/required-fqdn-endpoint?tabs=azure
#>

#Requires -Modules Az.Accounts, Az.Network, Az.Resources

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# CONSTANTS - AVD required service tags for NSG outbound rules
# ---------------------------------------------------------------------------

$script:AVDNsgRules = @(
    @{
        Name                     = 'Allow-AVD-ServiceTraffic'
        Priority                 = 100
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '443'
        DestinationAddressPrefix = 'WindowsVirtualDesktop'
        Description              = 'AVD service traffic including TCP-based RDP connectivity'
    }
    @{
        Name                     = 'Allow-AVD-UDP-Relay'
        Priority                 = 110
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Udp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '3478'
        DestinationAddressPrefix = 'WindowsVirtualDesktop'
        Description              = 'AVD relayed RDP connectivity (TURN/STUN)'
    }
    @{
        Name                     = 'Allow-AzureAD-Auth'
        Priority                 = 120
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '443'
        DestinationAddressPrefix = 'AzureActiveDirectory'
        Description              = 'Microsoft Entra ID authentication'
    }
    @{
        Name                     = 'Allow-AzureMonitor'
        Priority                 = 130
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '443'
        DestinationAddressPrefix = 'AzureMonitor'
        Description              = 'AVD agent diagnostics and telemetry'
    }
    @{
        Name                     = 'Allow-AzureCloud-Management'
        Priority                 = 140
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '443'
        DestinationAddressPrefix = 'AzureCloud'
        Description              = 'Azure portal and management plane'
    }
    @{
        Name                     = 'Allow-AzureFrontDoor'
        Priority                 = 150
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '443'
        DestinationAddressPrefix = 'AzureFrontDoor.Frontend'
        Description              = 'Azure Marketplace catalog artifacts'
    }
    @{
        Name                     = 'Allow-Storage-AgentUpdates'
        Priority                 = 160
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '443'
        DestinationAddressPrefix = 'Storage'
        Description              = 'AVD agent and SXS stack updates'
    }
    @{
        Name                     = 'Allow-KMS-Activation'
        Priority                 = 170
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '1688'
        DestinationAddressPrefix = 'Internet'
        Description              = 'Windows KMS activation (azkms.core.windows.net)'
    }
    @{
        Name                     = 'Allow-Certificates-HTTP'
        Priority                 = 180
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '80'
        DestinationAddressPrefix = 'Internet'
        Description              = 'Certificate OCSP and CRL checks (oneocsp.microsoft.com, ctldl.windowsupdate.com)'
    }
    @{
        Name                     = 'Allow-IMDS'
        Priority                 = 190
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '80'
        DestinationAddressPrefix = '169.254.169.254/32'
        Description              = 'Azure Instance Metadata Service'
    }
    @{
        Name                     = 'Allow-HealthMonitoring'
        Priority                 = 200
        Direction                = 'Outbound'
        Access                   = 'Allow'
        Protocol                 = 'Tcp'
        SourcePortRange          = '*'
        SourceAddressPrefix      = 'VirtualNetwork'
        DestinationPortRange     = '80'
        DestinationAddressPrefix = '168.63.129.16/32'
        Description              = 'Session host health monitoring (wireserver)'
    }
)

# ---------------------------------------------------------------------------
# HELPER FUNCTIONS
# ---------------------------------------------------------------------------

function Write-Banner {
    Write-Host ""
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host "    Azure Outbound Access Audit & Remediation Tool" -ForegroundColor Cyan
    Write-Host "    For Azure Virtual Desktop & Windows 365" -ForegroundColor Cyan
    Write-Host "    Context: Default Outbound Access retirement - March 31, 2026" -ForegroundColor Cyan
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    param(
        [string]$Title,
        [string[]]$Options
    )
    Write-Host ""
    Write-Host "  $Title" -ForegroundColor Yellow
    Write-Host "  $('-' * 60)" -ForegroundColor DarkGray
    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "  [$($i + 1)] $($Options[$i])" -ForegroundColor White
    }
    Write-Host "  [0] Exit" -ForegroundColor DarkGray
    Write-Host ""

    do {
        $selection = Read-Host "  Select an option"
        $parsed = $null
        $valid = [int]::TryParse($selection, [ref]$parsed) -and $parsed -ge 0 -and $parsed -le $Options.Count
        if (-not $valid) {
            Write-Host "  Invalid selection. Enter a number between 0 and $($Options.Count)." -ForegroundColor Red
        }
    } while (-not $valid)

    return $parsed
}

function Select-Subscription {
    Write-Host ""
    Write-Host "  Fetching available subscriptions..." -ForegroundColor DarkGray
    $subscriptions = Get-AzSubscription -ErrorAction Stop |
        Where-Object { $_.State -eq 'Enabled' } |
        Sort-Object Name

    if ($subscriptions.Count -eq 0) {
        Write-Host "  No enabled subscriptions found. Check your Azure login." -ForegroundColor Red
        return $null
    }

    Write-Host ""
    Write-Host "  Available Subscriptions:" -ForegroundColor Yellow
    Write-Host "  $('-' * 70)" -ForegroundColor DarkGray

    for ($i = 0; $i -lt $subscriptions.Count; $i++) {
        $sub = $subscriptions[$i]
        Write-Host "  [$($i + 1)] $($sub.Name) ($($sub.Id))" -ForegroundColor White
    }
    Write-Host ""

    do {
        $selection = Read-Host "  Select a subscription"
        $parsed = $null
        $valid = [int]::TryParse($selection, [ref]$parsed) -and $parsed -ge 1 -and $parsed -le $subscriptions.Count
        if (-not $valid) {
            Write-Host "  Invalid selection." -ForegroundColor Red
        }
    } while (-not $valid)

    $selected = $subscriptions[$parsed - 1]
    Set-AzContext -SubscriptionId $selected.Id -ErrorAction Stop | Out-Null
    Write-Host "  [OK] Context set to: $($selected.Name)" -ForegroundColor Green
    return $selected
}

function Get-ResourceGroupSelection {
    param(
        [string]$Prompt = "Enter the resource group name"
    )

    Write-Host ""
    $resourceGroups = Get-AzResourceGroup -ErrorAction Stop | Sort-Object ResourceGroupName
    Write-Host "  Available Resource Groups:" -ForegroundColor Yellow
    Write-Host "  $('-' * 60)" -ForegroundColor DarkGray

    for ($i = 0; $i -lt $resourceGroups.Count; $i++) {
        $rg = $resourceGroups[$i]
        Write-Host "  [$($i + 1)] $($rg.ResourceGroupName) ($($rg.Location))" -ForegroundColor White
    }
    Write-Host ""

    do {
        $selection = Read-Host "  $Prompt (enter number)"
        $parsed = $null
        $valid = [int]::TryParse($selection, [ref]$parsed) -and $parsed -ge 1 -and $parsed -le $resourceGroups.Count
        if (-not $valid) {
            Write-Host "  Invalid selection." -ForegroundColor Red
        }
    } while (-not $valid)

    return $resourceGroups[$parsed - 1]
}

function Confirm-Action {
    param([string]$Message)
    Write-Host ""
    $response = Read-Host "  $Message (y/n)"
    return ($response -eq 'y') -or ($response -eq 'Y')
}

function Get-TruncatedString {
    param([string]$Text, [int]$MaxLength)
    if ($Text.Length -le $MaxLength) { return $Text }
    return $Text.Substring(0, $MaxLength - 2) + '..'
}

# ---------------------------------------------------------------------------
# CORE: AUDIT FUNCTIONS
# ---------------------------------------------------------------------------

function Invoke-OutboundAccessAudit {
    <#
    .SYNOPSIS
        Scans all VNets and subnets in the current subscription for explicit outbound access.
    #>
    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "  Scanning virtual networks..." -ForegroundColor Cyan
    $vnets = Get-AzVirtualNetwork -ErrorAction Stop
    if ($vnets.Count -eq 0) {
        Write-Host "  No virtual networks found in this subscription." -ForegroundColor Yellow
        return @()
    }

    Write-Host "  Found $($vnets.Count) virtual network(s). Analyzing subnets..." -ForegroundColor DarkGray

    # Pre-fetch resources for cross-referencing
    Write-Host "  Loading network interfaces..." -ForegroundColor DarkGray
    $allNics = @(Get-AzNetworkInterface -ErrorAction SilentlyContinue)

    Write-Host "  Loading load balancers..." -ForegroundColor DarkGray
    $allLBs = @(Get-AzLoadBalancer -ErrorAction SilentlyContinue)

    Write-Host "  Loading Azure Firewalls..." -ForegroundColor DarkGray
    $allFirewalls = @(Get-AzFirewall -ErrorAction SilentlyContinue)

    $systemSubnets = @('GatewaySubnet', 'AzureBastionSubnet', 'AzureFirewallSubnet', 'AzureFirewallManagementSubnet', 'RouteServerSubnet')
    $results = New-Object System.Collections.ArrayList

    foreach ($vnet in $vnets) {
        foreach ($subnet in $vnet.Subnets) {
            $subnetName = $subnet.Name
            if ($subnetName -in $systemSubnets) { continue }

            $hasNatGateway = $null -ne $subnet.NatGateway
            $hasFirewall = $false
            $hasPublicIP = $false
            $hasLoadBalancer = $false
            $hasUdrToNva = $false
            $outboundMethods = New-Object System.Collections.ArrayList

            # Check NAT Gateway
            if ($hasNatGateway) { [void]$outboundMethods.Add('NAT Gateway') }

            # Check Azure Firewall (in same VNet)
            foreach ($fw in $allFirewalls) {
                foreach ($ipConfig in $fw.IpConfigurations) {
                    if ($ipConfig.Subnet.Id -and $ipConfig.Subnet.Id.StartsWith($vnet.Id, [System.StringComparison]::OrdinalIgnoreCase)) {
                        $hasFirewall = $true
                        break
                    }
                }
                if ($hasFirewall) { break }
            }

            # Check UDR for default route to NVA
            if ($subnet.RouteTable) {
                $rtParts = $subnet.RouteTable.Id -split '/'
                $rtRgName = $rtParts[4]
                $rtName = $rtParts[-1]
                $rt = Get-AzRouteTable -ResourceGroupName $rtRgName -Name $rtName -ErrorAction SilentlyContinue
                if ($rt) {
                    foreach ($route in $rt.Routes) {
                        if ($route.AddressPrefix -eq '0.0.0.0/0' -and $route.NextHopType -eq 'VirtualAppliance') {
                            $hasUdrToNva = $true
                            [void]$outboundMethods.Add("UDR to NVA ($($route.NextHopIpAddress))")
                            break
                        }
                    }
                }
            }

            if ($hasFirewall -and -not $hasUdrToNva) {
                [void]$outboundMethods.Add('Azure Firewall (in VNet, verify UDR)')
            }
            elseif ($hasFirewall -and $hasUdrToNva) {
                [void]$outboundMethods.Add('Azure Firewall')
            }

            # Check Public IPs on NICs in this subnet
            $subnetNics = @($allNics | Where-Object {
                $_.IpConfigurations | Where-Object { $_.Subnet.Id -eq $subnet.Id }
            })
            foreach ($nic in $subnetNics) {
                foreach ($ipConfig in $nic.IpConfigurations) {
                    if ($ipConfig.PublicIpAddress) {
                        $hasPublicIP = $true
                        [void]$outboundMethods.Add('Public IP on NIC')
                        break
                    }
                }
                if ($hasPublicIP) { break }
            }

            # Check Load Balancer
            if ($allLBs.Count -gt 0 -and $subnetNics.Count -gt 0) {
                $subnetNicIds = @($subnetNics | ForEach-Object { $_.Id })
                foreach ($lb in $allLBs) {
                    if ($lb.Sku.Name -ne 'Standard') { continue }
                    foreach ($bePool in $lb.BackendAddressPools) {
                        foreach ($beConfig in $bePool.BackendIpConfigurations) {
                            $nicId = ($beConfig.Id -split '/ipConfigurations/')[0]
                            if ($nicId -in $subnetNicIds) {
                                $hasLoadBalancer = $true
                                [void]$outboundMethods.Add('Standard Load Balancer')
                                break
                            }
                        }
                        if ($hasLoadBalancer) { break }
                    }
                    if ($hasLoadBalancer) { break }
                }
            }

            # Check defaultOutboundAccess property
            $isPrivateSubnet = $false
            if ($null -ne $subnet.DefaultOutboundAccess) {
                $isPrivateSubnet = -not $subnet.DefaultOutboundAccess
            }

            $hasExplicitOutbound = $hasNatGateway -or $hasPublicIP -or $hasLoadBalancer -or $hasUdrToNva

            if ($hasExplicitOutbound) {
                $status = 'OK'
            }
            elseif ($isPrivateSubnet) {
                $status = 'NO OUTBOUND'
            }
            else {
                $status = 'DEFAULT ONLY'
            }

            $methodsStr = 'None'
            if ($outboundMethods.Count -gt 0) {
                $methodsStr = $outboundMethods -join ', '
            }

            $row = [PSCustomObject]@{
                VNetName            = $vnet.Name
                VNetResourceGroup   = $vnet.ResourceGroupName
                VNetLocation        = $vnet.Location
                SubnetName          = $subnetName
                SubnetAddressPrefix = ($subnet.AddressPrefix -join ', ')
                IsPrivateSubnet     = $isPrivateSubnet
                HasNatGateway       = $hasNatGateway
                HasPublicIP         = $hasPublicIP
                HasLoadBalancer     = $hasLoadBalancer
                HasFirewall         = $hasFirewall
                HasUdrToNva         = $hasUdrToNva
                HasExplicitOutbound = $hasExplicitOutbound
                OutboundMethods     = $methodsStr
                Status              = $status
                HasNSG              = ($null -ne $subnet.NetworkSecurityGroup)
            }
            [void]$results.Add($row)
        }
    }

    return $results
}

function Show-AuditResults {
    <#
    .SYNOPSIS
        Visualizes the audit results in a formatted table with color-coded status.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object[]]$Results
    )

    if ($Results.Count -eq 0) {
        Write-Host "  No subnets to display." -ForegroundColor Yellow
        return
    }

    # Summary counts
    $total = $Results.Count
    $ok = @($Results | Where-Object { $_.Status -eq 'OK' }).Count
    $defaultOnly = @($Results | Where-Object { $_.Status -eq 'DEFAULT ONLY' }).Count
    $noOutbound = @($Results | Where-Object { $_.Status -eq 'NO OUTBOUND' }).Count

    Write-Host ""
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host "    AUDIT SUMMARY" -ForegroundColor Cyan
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host "    Total subnets scanned:    $total" -ForegroundColor White

    Write-Host -NoNewline "    Explicit outbound (OK):   " -ForegroundColor White
    Write-Host $ok -ForegroundColor Green

    Write-Host -NoNewline "    Default only (at risk):   " -ForegroundColor White
    Write-Host $defaultOnly -ForegroundColor Yellow

    Write-Host -NoNewline "    No outbound (broken):     " -ForegroundColor White
    Write-Host $noOutbound -ForegroundColor Red

    Write-Host "  ================================================================" -ForegroundColor Cyan

    # Detailed table
    Write-Host ""
    Write-Host "  DETAILED RESULTS" -ForegroundColor Yellow
    Write-Host "  $('-' * 120)" -ForegroundColor DarkGray

    $headerFmt = "  {0,-25} {1,-20} {2,-18} {3,-14} {4,-10} {5,-30}"
    $header = $headerFmt -f 'VNet', 'Subnet', 'Address Prefix', 'Status', 'NSG', 'Outbound Methods'
    Write-Host $header -ForegroundColor Cyan
    Write-Host "  $('-' * 120)" -ForegroundColor DarkGray

    foreach ($r in $Results) {
        $statusColor = switch ($r.Status) {
            'OK'           { 'Green' }
            'DEFAULT ONLY' { 'Yellow' }
            'NO OUTBOUND'  { 'Red' }
            default        { 'White' }
        }

        $vnetTrunc = Get-TruncatedString -Text $r.VNetName -MaxLength 24
        $subnetTrunc = Get-TruncatedString -Text $r.SubnetName -MaxLength 19
        $addrTrunc = Get-TruncatedString -Text $r.SubnetAddressPrefix -MaxLength 17
        $methodsTrunc = Get-TruncatedString -Text $r.OutboundMethods -MaxLength 29

        $line = "  {0,-25} {1,-20} {2,-18} " -f $vnetTrunc, $subnetTrunc, $addrTrunc
        Write-Host -NoNewline $line -ForegroundColor White
        Write-Host -NoNewline ("{0,-14} " -f $r.Status) -ForegroundColor $statusColor

        $nsgStatus = if ($r.HasNSG) { 'Yes' } else { 'No' }
        Write-Host -NoNewline ("{0,-10} " -f $nsgStatus) -ForegroundColor White
        Write-Host ("{0,-30}" -f $methodsTrunc) -ForegroundColor DarkGray
    }

    Write-Host "  $('-' * 120)" -ForegroundColor DarkGray

    # Export option
    if (Confirm-Action "Export results to CSV?") {
        $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $csvPath = Join-Path -Path (Get-Location) -ChildPath "OutboundAccessAudit-$timestamp.csv"
        $Results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
        Write-Host "  [OK] Results exported to: $csvPath" -ForegroundColor Green
    }
}

# ---------------------------------------------------------------------------
# CORE: DEPLOYMENT FUNCTIONS
# ---------------------------------------------------------------------------

function Deploy-NatGatewayToExistingSubnet {
    <#
    .SYNOPSIS
        Deploys a NAT Gateway with a Public IP and associates it with an existing subnet.
    #>
    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "  -- Deploy NAT Gateway to Existing Subnet --" -ForegroundColor Yellow
    Write-Host ""

    # Select resource group
    $rg = Get-ResourceGroupSelection -Prompt "Select the resource group containing the VNet"
    $rgName = $rg.ResourceGroupName
    $location = $rg.Location

    # Select VNet
    $vnets = @(Get-AzVirtualNetwork -ResourceGroupName $rgName -ErrorAction Stop)
    if ($vnets.Count -eq 0) {
        Write-Host "  No VNets found in resource group '$rgName'." -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host "  Available VNets:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $vnets.Count; $i++) {
        Write-Host "  [$($i + 1)] $($vnets[$i].Name)" -ForegroundColor White
    }
    do {
        $vnetSel = Read-Host "  Select VNet"
        $parsed = $null
        $valid = [int]::TryParse($vnetSel, [ref]$parsed) -and $parsed -ge 1 -and $parsed -le $vnets.Count
    } while (-not $valid)
    $selectedVnet = $vnets[$parsed - 1]

    # Select Subnet
    $systemSubnets = @('GatewaySubnet', 'AzureBastionSubnet', 'AzureFirewallSubnet', 'AzureFirewallManagementSubnet', 'RouteServerSubnet')
    $subnets = @($selectedVnet.Subnets | Where-Object { $_.Name -notin $systemSubnets })
    if ($subnets.Count -eq 0) {
        Write-Host "  No eligible subnets found." -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host "  Available Subnets:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $subnets.Count; $i++) {
        $natInfo = ''
        if ($subnets[$i].NatGateway) { $natInfo = ' [NAT Gateway already attached]' }
        $addrPrefix = $subnets[$i].AddressPrefix -join ', '
        Write-Host "  [$($i + 1)] $($subnets[$i].Name) ($addrPrefix)$natInfo" -ForegroundColor White
    }
    do {
        $subnetSel = Read-Host "  Select subnet"
        $parsed = $null
        $valid = [int]::TryParse($subnetSel, [ref]$parsed) -and $parsed -ge 1 -and $parsed -le $subnets.Count
    } while (-not $valid)
    $selectedSubnet = $subnets[$parsed - 1]

    if ($selectedSubnet.NatGateway) {
        Write-Host "  This subnet already has a NAT Gateway attached." -ForegroundColor Yellow
        if (-not (Confirm-Action "Continue and replace the existing NAT Gateway?")) { return }
    }

    # Naming
    $baseName = Read-Host "  Enter a base name for resources (e.g. avd-prod-westeu)"
    if ([string]::IsNullOrWhiteSpace($baseName)) {
        Write-Host "  Base name cannot be empty." -ForegroundColor Red
        return
    }

    $pipName = "pip-natgw-$baseName"
    $natGwName = "natgw-$baseName"

    Write-Host ""
    Write-Host "  Deployment Plan:" -ForegroundColor Yellow
    Write-Host "  - Public IP:    $pipName" -ForegroundColor White
    Write-Host "  - NAT Gateway:  $natGwName" -ForegroundColor White
    Write-Host "  - Location:     $location" -ForegroundColor White
    Write-Host "  - VNet:         $($selectedVnet.Name)" -ForegroundColor White
    Write-Host "  - Subnet:       $($selectedSubnet.Name)" -ForegroundColor White

    if (-not (Confirm-Action "Deploy these resources?")) { return }

    # Deploy Public IP
    Write-Host ""
    Write-Host "  Creating Public IP..." -ForegroundColor DarkGray
    $pipParams = @{
        ResourceGroupName = $rgName
        Name              = $pipName
        Location          = $location
        Sku               = 'Standard'
        AllocationMethod  = 'Static'
        ErrorAction       = 'Stop'
    }
    $pip = New-AzPublicIpAddress @pipParams
    Write-Host "  [OK] Public IP created: $($pip.IpAddress)" -ForegroundColor Green

    # Deploy NAT Gateway
    Write-Host "  Creating NAT Gateway..." -ForegroundColor DarkGray
    $natGwParams = @{
        ResourceGroupName    = $rgName
        Name                 = $natGwName
        Location             = $location
        Sku                  = 'Standard'
        PublicIpAddress      = $pip
        IdleTimeoutInMinutes = 10
        ErrorAction          = 'Stop'
    }
    $natGw = New-AzNatGateway @natGwParams
    Write-Host "  [OK] NAT Gateway created: $natGwName" -ForegroundColor Green

    # Associate with subnet
    Write-Host "  Associating NAT Gateway with subnet..." -ForegroundColor DarkGray
    $selectedSubnet.NatGateway = $natGw
    $selectedVnet | Set-AzVirtualNetwork -ErrorAction Stop | Out-Null
    Write-Host "  [OK] NAT Gateway associated with subnet '$($selectedSubnet.Name)'" -ForegroundColor Green

    Write-Host ""
    Write-Host "  Deployment complete." -ForegroundColor Green
}

function Deploy-NewVNetWithNatGateway {
    <#
    .SYNOPSIS
        Deploys a new VNet with a subnet and NAT Gateway attached.
    #>
    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "  -- Deploy New VNet with NAT Gateway --" -ForegroundColor Yellow
    Write-Host ""

    # Select resource group
    $rg = Get-ResourceGroupSelection -Prompt "Select the target resource group"
    $rgName = $rg.ResourceGroupName
    $location = $rg.Location

    # Gather parameters
    $baseName = Read-Host "  Enter a base name for resources (e.g. avd-prod-westeu)"
    if ([string]::IsNullOrWhiteSpace($baseName)) {
        Write-Host "  Base name cannot be empty." -ForegroundColor Red
        return
    }

    $vnetAddressSpace = Read-Host "  Enter VNet address space (default: 10.100.0.0/16)"
    if ([string]::IsNullOrWhiteSpace($vnetAddressSpace)) { $vnetAddressSpace = '10.100.0.0/16' }

    $subnetAddressPrefix = Read-Host "  Enter subnet address prefix (default: 10.100.1.0/24)"
    if ([string]::IsNullOrWhiteSpace($subnetAddressPrefix)) { $subnetAddressPrefix = '10.100.1.0/24' }

    $subnetName = Read-Host "  Enter subnet name (default: snet-avd-sessionhosts)"
    if ([string]::IsNullOrWhiteSpace($subnetName)) { $subnetName = 'snet-avd-sessionhosts' }

    $vnetName = "vnet-$baseName"
    $pipName = "pip-natgw-$baseName"
    $natGwName = "natgw-$baseName"

    Write-Host ""
    Write-Host "  Deployment Plan:" -ForegroundColor Yellow
    Write-Host "  - Resource Group: $rgName" -ForegroundColor White
    Write-Host "  - Location:       $location" -ForegroundColor White
    Write-Host "  - VNet:           $vnetName ($vnetAddressSpace)" -ForegroundColor White
    Write-Host "  - Subnet:         $subnetName ($subnetAddressPrefix)" -ForegroundColor White
    Write-Host "  - Public IP:      $pipName" -ForegroundColor White
    Write-Host "  - NAT Gateway:    $natGwName" -ForegroundColor White

    if (-not (Confirm-Action "Deploy these resources?")) { return }

    # Deploy Public IP
    Write-Host ""
    Write-Host "  Creating Public IP..." -ForegroundColor DarkGray
    $pipParams = @{
        ResourceGroupName = $rgName
        Name              = $pipName
        Location          = $location
        Sku               = 'Standard'
        AllocationMethod  = 'Static'
        ErrorAction       = 'Stop'
    }
    $pip = New-AzPublicIpAddress @pipParams
    Write-Host "  [OK] Public IP created: $($pip.IpAddress)" -ForegroundColor Green

    # Deploy NAT Gateway
    Write-Host "  Creating NAT Gateway..." -ForegroundColor DarkGray
    $natGwParams = @{
        ResourceGroupName    = $rgName
        Name                 = $natGwName
        Location             = $location
        Sku                  = 'Standard'
        PublicIpAddress      = $pip
        IdleTimeoutInMinutes = 10
        ErrorAction          = 'Stop'
    }
    $natGw = New-AzNatGateway @natGwParams
    Write-Host "  [OK] NAT Gateway created: $natGwName" -ForegroundColor Green

    # Deploy VNet with Subnet
    Write-Host "  Creating VNet and Subnet..." -ForegroundColor DarkGray
    $subnetParams = @{
        Name          = $subnetName
        AddressPrefix = $subnetAddressPrefix
        NatGateway    = $natGw
        ErrorAction   = 'Stop'
    }
    $subnetConfig = New-AzVirtualNetworkSubnetConfig @subnetParams

    $vnetParams = @{
        ResourceGroupName = $rgName
        Name              = $vnetName
        Location          = $location
        AddressPrefix     = $vnetAddressSpace
        Subnet            = $subnetConfig
        ErrorAction       = 'Stop'
    }
    $vnet = New-AzVirtualNetwork @vnetParams
    Write-Host "  [OK] VNet created: $vnetName" -ForegroundColor Green
    Write-Host "  [OK] Subnet created: $subnetName (NAT Gateway attached)" -ForegroundColor Green

    Write-Host ""
    Write-Host "  Deployment complete." -ForegroundColor Green

    return @{
        VNet              = $vnet
        ResourceGroupName = $rgName
        SubnetName        = $subnetName
    }
}

function Deploy-AvdNsgAndAsg {
    <#
    .SYNOPSIS
        Deploys an NSG with AVD-required outbound rules and an ASG for AVD session hosts.
        Optionally associates the NSG with an existing subnet.
    #>
    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "  -- Deploy AVD-Ready NSG & ASG --" -ForegroundColor Yellow
    Write-Host ""

    # Select resource group
    $rg = Get-ResourceGroupSelection -Prompt "Select the target resource group"
    $rgName = $rg.ResourceGroupName
    $location = $rg.Location

    $baseName = Read-Host "  Enter a base name for resources (e.g. avd-prod-westeu)"
    if ([string]::IsNullOrWhiteSpace($baseName)) {
        Write-Host "  Base name cannot be empty." -ForegroundColor Red
        return
    }

    $nsgName = "nsg-$baseName"
    $asgName = "asg-avd-sessionhosts-$baseName"

    Write-Host ""
    Write-Host "  Deployment Plan:" -ForegroundColor Yellow
    Write-Host "  - NSG: $nsgName" -ForegroundColor White
    Write-Host "  - ASG: $asgName" -ForegroundColor White
    Write-Host "  - Location: $location" -ForegroundColor White
    Write-Host ""
    Write-Host "  NSG Outbound Rules:" -ForegroundColor Yellow
    Write-Host "  $('-' * 80)" -ForegroundColor DarkGray

    foreach ($rule in $script:AVDNsgRules) {
        $ruleLine = "  P{0,-4} {1,-35} -> {2,-30} :{3}" -f $rule.Priority, $rule.Name, $rule.DestinationAddressPrefix, $rule.DestinationPortRange
        Write-Host $ruleLine -ForegroundColor White
    }
    Write-Host "  $('-' * 80)" -ForegroundColor DarkGray

    if (-not (Confirm-Action "Deploy NSG and ASG?")) { return }

    # Deploy ASG
    Write-Host ""
    Write-Host "  Creating Application Security Group..." -ForegroundColor DarkGray
    $asgParams = @{
        ResourceGroupName = $rgName
        Name              = $asgName
        Location          = $location
        ErrorAction       = 'Stop'
    }
    $asg = New-AzApplicationSecurityGroup @asgParams
    Write-Host "  [OK] ASG created: $asgName" -ForegroundColor Green

    # Build NSG rules
    Write-Host "  Creating NSG rules..." -ForegroundColor DarkGray
    $nsgRuleConfigs = New-Object System.Collections.ArrayList

    foreach ($rule in $script:AVDNsgRules) {
        $ruleParams = @{
            Name                     = $rule.Name
            Priority                 = $rule.Priority
            Direction                = $rule.Direction
            Access                   = $rule.Access
            Protocol                 = $rule.Protocol
            SourcePortRange          = $rule.SourcePortRange
            SourceAddressPrefix      = $rule.SourceAddressPrefix
            DestinationPortRange     = $rule.DestinationPortRange
            DestinationAddressPrefix = $rule.DestinationAddressPrefix
            Description              = $rule.Description
            ErrorAction              = 'Stop'
        }
        $ruleConfig = New-AzNetworkSecurityRuleConfig @ruleParams
        [void]$nsgRuleConfigs.Add($ruleConfig)
    }

    # Add a default deny-all outbound rule at low priority
    $denyParams = @{
        Name                     = 'Deny-All-Outbound'
        Priority                 = 4096
        Direction                = 'Outbound'
        Access                   = 'Deny'
        Protocol                 = '*'
        SourcePortRange          = '*'
        SourceAddressPrefix      = '*'
        DestinationPortRange     = '*'
        DestinationAddressPrefix = '*'
        Description              = 'Explicit deny-all outbound (AVD required rules are allowed above)'
        ErrorAction              = 'Stop'
    }
    $denyAllRule = New-AzNetworkSecurityRuleConfig @denyParams
    [void]$nsgRuleConfigs.Add($denyAllRule)

    # Deploy NSG
    Write-Host "  Creating Network Security Group..." -ForegroundColor DarkGray
    $nsgParams = @{
        ResourceGroupName = $rgName
        Name              = $nsgName
        Location          = $location
        SecurityRules     = $nsgRuleConfigs
        ErrorAction       = 'Stop'
    }
    $nsg = New-AzNetworkSecurityGroup @nsgParams
    Write-Host "  [OK] NSG created: $nsgName ($($nsgRuleConfigs.Count) rules)" -ForegroundColor Green

    # Ask to associate with a subnet
    if (Confirm-Action "Associate this NSG with a subnet now?") {
        $vnets = @(Get-AzVirtualNetwork -ResourceGroupName $rgName -ErrorAction SilentlyContinue)
        if ($vnets.Count -eq 0) {
            $vnets = @(Get-AzVirtualNetwork -ErrorAction SilentlyContinue)
        }

        if ($vnets.Count -gt 0) {
            Write-Host ""
            Write-Host "  Available VNets:" -ForegroundColor Yellow
            for ($i = 0; $i -lt $vnets.Count; $i++) {
                Write-Host "  [$($i + 1)] $($vnets[$i].Name) ($($vnets[$i].ResourceGroupName))" -ForegroundColor White
            }
            do {
                $vnetSel = Read-Host "  Select VNet"
                $parsed = $null
                $valid = [int]::TryParse($vnetSel, [ref]$parsed) -and $parsed -ge 1 -and $parsed -le $vnets.Count
            } while (-not $valid)
            $selectedVnet = $vnets[$parsed - 1]

            $systemSubnets = @('GatewaySubnet', 'AzureBastionSubnet', 'AzureFirewallSubnet', 'AzureFirewallManagementSubnet', 'RouteServerSubnet')
            $subnets = @($selectedVnet.Subnets | Where-Object { $_.Name -notin $systemSubnets })

            if ($subnets.Count -gt 0) {
                Write-Host ""
                Write-Host "  Available Subnets:" -ForegroundColor Yellow
                for ($i = 0; $i -lt $subnets.Count; $i++) {
                    $addrPrefix = $subnets[$i].AddressPrefix -join ', '
                    Write-Host "  [$($i + 1)] $($subnets[$i].Name) ($addrPrefix)" -ForegroundColor White
                }
                do {
                    $subnetSel = Read-Host "  Select subnet"
                    $parsed = $null
                    $valid = [int]::TryParse($subnetSel, [ref]$parsed) -and $parsed -ge 1 -and $parsed -le $subnets.Count
                } while (-not $valid)
                $selectedSubnet = $subnets[$parsed - 1]

                Write-Host "  Associating NSG with subnet '$($selectedSubnet.Name)'..." -ForegroundColor DarkGray
                $selectedSubnet.NetworkSecurityGroup = $nsg
                $selectedVnet | Set-AzVirtualNetwork -ErrorAction Stop | Out-Null
                Write-Host "  [OK] NSG associated with subnet '$($selectedSubnet.Name)'" -ForegroundColor Green
            }
            else {
                Write-Host "  No eligible subnets found." -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "  No VNets found. You can associate the NSG manually later." -ForegroundColor Yellow
        }
    }

    Write-Host ""
    Write-Host "  Deployment complete." -ForegroundColor Green
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Associate AVD session host NICs with ASG '$asgName'" -ForegroundColor White
    Write-Host "  2. Validate connectivity using the AVD Agent URL Tool" -ForegroundColor White
    Write-Host "     https://learn.microsoft.com/en-us/azure/virtual-desktop/check-access-validate-required-fqdn-endpoint" -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# MAIN ENTRY POINT
# ---------------------------------------------------------------------------

function Start-OutboundAccessTool {
    <#
    .SYNOPSIS
        Main entry point for the Azure Outbound Access Audit & Remediation Tool.
    #>
    [CmdletBinding()]
    param()

    Write-Banner

    # Ensure Azure connection
    try {
        $context = Get-AzContext -ErrorAction Stop
        if (-not $context) { throw "No Azure context" }
        Write-Host "  Signed in as: $($context.Account.Id)" -ForegroundColor DarkGray
        Write-Host "  Current subscription: $($context.Subscription.Name)" -ForegroundColor DarkGray
    }
    catch {
        Write-Host "  Not signed in to Azure. Launching login..." -ForegroundColor Yellow
        Connect-AzAccount -ErrorAction Stop
    }

    # Select subscription
    $subscription = Select-Subscription
    if (-not $subscription) { return }

    # Main loop
    $continue = $true
    while ($continue) {
        $choice = Show-Menu -Title "What would you like to do?" -Options @(
            "Audit - Scan all VNets for outbound access configuration"
            "Deploy NAT Gateway to an existing subnet"
            "Deploy a new VNet with NAT Gateway attached"
            "Deploy AVD-ready NSG & ASG (required outbound rules)"
            "Switch subscription"
        )

        switch ($choice) {
            0 { $continue = $false }
            1 {
                $results = Invoke-OutboundAccessAudit
                if ($results.Count -gt 0) {
                    Show-AuditResults -Results $results
                }
            }
            2 { Deploy-NatGatewayToExistingSubnet }
            3 { Deploy-NewVNetWithNatGateway }
            4 { Deploy-AvdNsgAndAsg }
            5 {
                $subscription = Select-Subscription
                if (-not $subscription) { $continue = $false }
            }
        }
    }

    Write-Host ""
    Write-Host "  Done. Stay secure." -ForegroundColor Green
    Write-Host ""
}

# Run the tool
Start-OutboundAccessTool
