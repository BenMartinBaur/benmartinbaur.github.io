# Windows 365 Baseline Deployment

Modular Microsoft Graph PowerShell automation for deploying Intune + Windows 365 baseline policies following consistent naming conventions.

## Prerequisites

- **PowerShell 7+**
- **Microsoft.Graph PowerShell SDK**

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

- **Permissions** (least-privilege roles):
  - Groups Administrator (for Entra ID groups)
  - Intune Administrator (for device policies)
  - Conditional Access Administrator (for CA policies)

## Quick Start

1. Edit `config/baseline-config.json` with your tenant ID and Windows 365 plan IDs.
2. Run the orchestrator:

```powershell
# Deploy everything
.\Deploy-W365Baseline.ps1

# Deploy only groups and compliance policies
.\Deploy-W365Baseline.ps1 -ModulesOnly "02,04"

# Preview what would be deployed
.\Deploy-W365Baseline.ps1 -WhatIf
```

## Modules

| # | Module | Description |
|---|--------|-------------|
| 01 | `Connect.ps1` | Authenticate to Microsoft Graph |
| 02 | `Groups.ps1` | Create Entra ID security groups |
| 03 | `AssignmentFilters.ps1` | Create Intune assignment filters |
| 04 | `CompliancePolicy.ps1` | Create compliance policies (BitLocker excluded) |
| 05 | `DeviceConfiguration.ps1` | Create device configuration profiles (OMA-URI) |
| 06 | `UpdateRings.ps1` | Create Windows Update rings (Pilot/Fast/Broad) |
| 07 | `SecurityBaseline.ps1` | Guidance for manual security baseline deployment |
| 08 | `ConditionalAccess.ps1` | Create CA policies (report-only mode) |

## Safety

- All policies are created **without assignments** — assign manually after review.
- Conditional Access policies are created in **report-only** mode.
- Each module checks for existing resources and **skips duplicates**.
- Use `-WhatIf` to preview changes before deploying.

## Configuration

Edit `config/baseline-config.json` to customize:
- Group names and dynamic membership rules
- Compliance policy settings
- Update ring deferral periods
- Conditional Access policy targets
- Assignment filter rules

## Naming Convention

All resources follow the pattern documented in the companion blog post:

| Object | Pattern | Example |
|--------|---------|---------|
| Group | `GRP-<Scope>-<Platform>-<Purpose>` | `GRP-All-W365-Enterprise` |
| Compliance | `CMP-<Platform>-<Level>` | `CMP-W365-Standard` |
| Config Profile | `CFG-<Platform>-<Category>-<Detail>` | `CFG-W365-Security-Baseline` |
| Update Ring | `UPD-<Platform>-<Ring>` | `UPD-W365-Pilot` |
| CA Policy | `CA-<Number>-<Purpose>` | `CA-101-RequireMFA-CloudPC` |
| Filter | `FLT-<Platform>-<Property>-<Value>` | `FLT-W365-Model-CloudPC` |
