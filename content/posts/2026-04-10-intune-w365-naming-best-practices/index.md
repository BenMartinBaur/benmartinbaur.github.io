---
layout: post
title: "Intune & Windows 365 – Naming Conventions & Best Practices Cheatsheet"
description: "A practical guide to naming conventions for devices, policies, groups, and provisioning policies in Microsoft Intune and Windows 365. Includes a modular Microsoft Graph automation to deploy baseline policies."
date: 2026-04-10
image: featured.jpg
category: build
tags:
  - Windows 365
  - Intune
  - Best Practices
  - Automation
reading_time: "15 min read"
---

If you've ever inherited an Intune tenant where policies are named `Test Policy 2 - Copy (final_v3)` — you know the pain. Naming conventions aren't glamorous, but they're the foundation of a manageable, scalable endpoint environment. This post covers battle-tested naming patterns for **Microsoft Intune** and **Windows 365**, distilled from Microsoft documentation, MVP community guidance, and my own field experience deploying Cloud PCs at scale.

> ⚠️ NEVER DEPLOY WITHOUT TESTING! ⚠️

At the end you'll find a **modular Microsoft Graph PowerShell automation** that deploys baseline policies following these conventions — ready to fork and adapt.

---

## TL;DR — Naming Convention Quick Reference

| Object Type | Pattern | Example |
|---|---|---|
| **Entra ID Group** | `GRP-<Scope>-<Platform>-<Purpose>` | `GRP-IT-W365-Developers` |
| **Device Configuration Profile** | `CFG-<Platform>-<Category>-<Detail>` | `CFG-W365-Security-Baseline` |
| **Compliance Policy** | `CMP-<Platform>-<Level>` | `CMP-W365-Standard` |
| **Conditional Access Policy** | `CA-<Number>-<Purpose>` | `CA-101-RequireMFA-CloudPC` |
| **App Protection Policy** | `APP-<Platform>-<AppName>-<Action>` | `APP-W365-Office-DLP` |
| **Windows Update Ring** | `UPD-<Platform>-<Ring>` | `UPD-W365-Pilot` |
| **Provisioning Policy** | `PP-<LicenseType>-<Region>-<UseCase>` | `PP-Enterprise-WEU-Developers` |
| **Azure Network Connection** | `ANC-<Region>-<VNet>` | `ANC-WestEurope-Hub` |
| **Cloud PC Device Name** | `<Prefix>-%RAND:Y%` | `CPC-%RAND:5%` |
| **Assignment Filter** | `FLT-<Platform>-<Property>-<Value>` | `FLT-W365-Model-CloudPC` |
| **Security Baseline** | `SBL-<Platform>-<Version>` | `SBL-W365-24H1` |
| **Scope Tag** | `TAG-<Department or Region>` | `TAG-EMEA-IT` |

> **Golden Rule:** Every name should tell you *what it is*, *what platform it targets*, and *why it exists* — without clicking into it.

---

## 1. Why Naming Conventions Matter

In a mature Intune environment you might manage **hundreds** of policies across device configuration, compliance, app protection, conditional access, update rings, and Windows 365 provisioning policies. Without a clear naming standard:

- **Troubleshooting is slow** — you can't tell which policy does what from the list view.
- **Delegation breaks down** — scoped admins can't confidently manage their area.
- **Drift accumulates** — duplicate or conflicting policies pile up undetected.
- **Automation is fragile** — scripts can't reliably filter or target resources.

Microsoft's own planning guidance recommends mapping management groups, policies, and success metrics early in the deployment. The naming convention is the glue that holds this together.

---

## 2. Naming Pattern Deep-Dive

### 2.1 Entra ID Groups

Groups drive every assignment in Intune. A clean group naming standard is the single highest-leverage improvement you can make.

**Pattern:** `GRP-<Scope>-<Platform>-<Purpose>`

| Component | Values | Description |
|---|---|---|
| `GRP` | Fixed prefix | Identifies the object as a group |
| `Scope` | `All`, `IT`, `HR`, `Finance`, department or region | Who the group applies to |
| `Platform` | `W365`, `Win`, `iOS`, `Android`, `Mac` | Target platform |
| `Purpose` | Descriptive name | What the group is for |

**Examples:**
- `GRP-All-W365-Users` — All Windows 365 licensed users
- `GRP-IT-W365-Developers` — IT developers with Cloud PCs
- `GRP-EMEA-W365-Frontline` — Frontline Cloud PC users in EMEA
- `GRP-All-W365-Pilot` — Pilot ring for Cloud PC rollout

**Dynamic membership rules** (Entra ID P1 required):
```
(user.assignedPlans -any (assignedPlan.servicePlanId -eq "your-w365-plan-id" -and assignedPlan.capabilityStatus -eq "Enabled"))
```

> **Finding your service plan ID:** Run `Get-MgSubscribedSku | Select-Object -ExpandProperty ServicePlans | Where-Object { $_.ServicePlanName -like '*W365*' }` to list your tenant's Windows 365 plan GUIDs. Note: initial dynamic group population can take up to 24 hours for large tenants. For cost-conscious deployments, use a mix of dynamic groups (license-based membership) and assigned groups (pilot/exception populations) — each dynamic group requires Entra ID P1 licensing for all evaluated users.

### 2.2 Device Configuration Profiles

**Pattern:** `CFG-<Platform>-<Category>-<Detail>`

| Component | Values |
|---|---|
| `CFG` | Fixed prefix |
| `Platform` | `W365`, `Win`, `iOS`, `Mac` |
| `Category` | `Security`, `Network`, `UX`, `Restrictions`, `Delivery` |
| `Detail` | Specific setting area |

**Examples:**
- `CFG-W365-Security-Baseline` — Windows 365 security baseline profile
- `CFG-W365-Network-VPN-Split` — VPN split-tunneling for Cloud PCs
- `CFG-W365-UX-StartMenu` — Start menu customization
- `CFG-W365-Restrictions-USB` — USB storage restrictions

### 2.3 Compliance Policies

**Pattern:** `CMP-<Platform>-<Level>`

| Level | Description |
|---|---|
| `Minimal` | Basic requirements (OS version, encryption) |
| `Standard` | Corporate baseline (password, firewall, antivirus) |
| `Strict` | High-security (Defender ATP risk score, jailbreak detection) |

**Examples:**
- `CMP-W365-Standard` — Standard compliance for Cloud PCs
- `CMP-W365-Strict` — High-security compliance (e.g., finance, HR)

> **Note for Cloud PCs:** BitLocker is not applicable to Cloud PCs — they are protected by **Azure managed disk encryption** (server-side encryption at rest) at the storage layer. Exclude BitLocker compliance checks from policies targeting Windows 365 devices. The virtual TPM 2.0 is still present for other security functions.

### 2.4 Conditional Access Policies

**Pattern:** `CA-<Number>-<Purpose>`

Use a numbering scheme grouped by function:

| Range | Function |
|---|---|
| `001–099` | Global / baseline policies |
| `100–199` | Cloud PC / VDI policies |
| `200–299` | Mobile / BYOD policies |
| `300–399` | Application-specific policies |
| `400–499` | Agent / automated workload policies |

**Examples:**
- `CA-001-BlockLegacyAuth` — Block legacy authentication globally
- `CA-101-RequireMFA-CloudPC` — Require MFA for Cloud PC access
- `CA-102-RequireCompliance-CloudPC` — Require device compliance for Cloud PCs
- `CA-103-BlockNonManagedDevices-CloudPC` — Block unmanaged device access to Cloud PCs

### 2.5 Windows 365 Provisioning Policies

This is the most critical naming area for Windows 365.

**Pattern:** `PP-<LicenseType>-<Region>-<UseCase>`

| Component | Values |
|---|---|
| `PP` | Fixed prefix for Provisioning Policy |
| `LicenseType` | `Ent` (Enterprise), `FL-Ded` (Frontline Dedicated), `FL-Shared` (Frontline Shared), `Biz` (Business) |
| `Region` | `WEU`, `NEU`, `EUS`, `WUS`, `SEA`, etc. |
| `UseCase` | `Developers`, `GeneralWorkers`, `Kiosk`, `Frontline`, etc. |

**Examples:**
- `PP-Ent-WEU-Developers` — Enterprise Cloud PCs for developers in West Europe
- `PP-FL-Shared-WEU-Retail` — Frontline shared Cloud PCs for retail in West Europe
- `PP-Ent-EUS-General` — Enterprise Cloud PCs for general workers in East US

### 2.6 Cloud PC Device Names

Windows 365 supports device name templates in provisioning policies. The template configures the NetBIOS name (max 15 characters).

**Rules for Enterprise and Frontline Dedicated:**
- 5–15 characters
- Letters, numbers, hyphens only
- Must include `%RAND:Y%` where Y ≥ 5
- Optionally include `%USERNAME:X%` for first X characters of username

**Rules for Frontline Shared:**
- 5–15 characters total
- Prefix ≤ 7 characters
- Must include `%RAND:Y%` where Y ≥ 8

**Recommended Templates:**

| Use Case | Template | Example Output |
|---|---|---|
| Enterprise General | `CPC-%RAND:5%` | `CPC-A7K2M` |
| Enterprise by Use Case | `DEV-%RAND:5%` | `DEV-B3F9X` |
| Frontline Shared | `FLR-%RAND:11%` | `FLR-A7K2M3B9X4F` |
| Enterprise with Username | `%USERNAME:4%-%RAND:5%` | `JDOE-C8H2P` |

### 2.7 Azure Network Connections

**Pattern:** `ANC-<Region>-<NetworkPurpose>`

**Examples:**
- `ANC-WestEurope-Hub` — Main hub network in West Europe
- `ANC-EastUS-Dev` — Development network in East US

### 2.8 Assignment Filters

**Pattern:** `FLT-<Platform>-<Property>-<Value>`

**Examples:**
- `FLT-W365-Model-CloudPC` — Filter for Cloud PC device model (`device.model -contains "Cloud PC"` matches both `"Cloud PC Enterprise"` and `"Cloud PC Business"` — use `-eq` for precise targeting)
- `FLT-Win-OS-22H2` — Filter for Windows 22H2 devices
- `FLT-W365-Ownership-Corporate` — Filter for corporate-owned Cloud PCs

### 2.9 Update Rings

**Pattern:** `UPD-<Platform>-<Ring>`

| Ring | Description |
|---|---|
| `Pilot` | IT / early adopters (1–3 day deferral) |
| `Fast` | Broader test group (7 day deferral) |
| `Broad` | General population (14 day deferral) |
| `Critical` | Business-critical users (21+ day deferral) |

**Examples:**
- `UPD-W365-Pilot` — Pilot update ring for Cloud PCs
- `UPD-W365-Broad` — Broad rollout update ring

> **Tip:** Consider Windows Autopatch for automated, ring-based update management on Cloud PCs. If you enable Autopatch, it creates its own ring groups and policies — don't apply custom-named rings to the same device population. Choose one approach per device group: Autopatch-managed **or** custom-named rings, not both.

> **Baseline versioning:** When Microsoft releases a new baseline version (e.g., 25H1), deploy the new baseline alongside the existing one (`SBL-W365-25H1`) and migrate group assignments gradually. Don't rename existing baselines — Intune tracks policies by internal ID, not name, and renaming obscures audit history.

---

## 3. Windows 365 Provisioning Best Practices

Beyond naming, here are key best practices for Windows 365 provisioning:

### 3.1 Images

| Approach | When to Use |
|---|---|
| **Gallery Image** | Standard deployments, quick start, no custom apps needed |
| **Custom Image** | LOB apps pre-installed, specific configurations, compliance requirements |

> Always test custom images in a pilot provisioning policy before broad rollout.

### 3.2 Join Type Selection

| Join Type | When to Use |
|---|---|
| **Microsoft Entra Join** (Microsoft Hosted Network) | Cloud-native organizations, no on-prem dependency, simplest setup |
| **Microsoft Entra Join** (ANC) | Cloud-native but need to reach on-prem resources via VNet |
| **Hybrid Microsoft Entra Join** | Organizations still dependent on Active Directory, GPO, or on-prem apps |

> **Recommendation:** Prefer Microsoft Entra Join with Microsoft Hosted Network for maximum resiliency. Use the *All default regions within the geography* option unless you have data residency requirements.

### 3.3 Security Baseline

Deploy the **Windows 365 Security Baseline (24H1)** to all Cloud PCs. It covers:
- Windows 11/10 hardening
- Microsoft Edge security
- Microsoft Defender for Endpoint configuration

Apply it via: **Intune Admin Center → Endpoint Security → Security Baselines → Windows 365 Security Baseline Version 24H1**

### 3.4 Conditional Access for Cloud PCs

At minimum, configure:
1. **Require MFA** for all Cloud PC connections
2. **Require compliant device** for Cloud PC access (or exclude if you want BYOD access to Cloud PCs)
3. **Block legacy authentication** globally
4. **Session controls** — consider sign-in frequency and persistent browser session settings

### 3.5 Scope Tags for Delegation

Use scope tags when multiple teams manage different Cloud PC populations. **Important:** Scope tags alone don't enforce delegation — they must be paired with **custom Intune RBAC role assignments** that scope the admin to specific tags. Assign tags to both the policies/devices and the admin role assignment to enforce delegation boundaries.

| Tag | Scope |
|---|---|
| `TAG-EMEA-IT` | EMEA IT admins manage EMEA Cloud PCs |
| `TAG-US-IT` | US IT admins manage US Cloud PCs |
| `TAG-Global-Security` | Security team manages security baselines globally |

---

## 4. Putting It All Together — Example Deployment Matrix

| Object | Name | Target Group | Notes |
|---|---|---|---|
| **Group** | `GRP-All-W365-Enterprise` | — | Dynamic: W365 Enterprise licensed users |
| **Group** | `GRP-IT-W365-Pilot` | — | Assigned: IT early adopters |
| **Provisioning Policy** | `PP-Ent-WEU-General` | `GRP-All-W365-Enterprise` | Entra Join, Microsoft Hosted, WEU |
| **Security Baseline** | `SBL-W365-24H1` | `GRP-All-W365-Enterprise` | Windows 365 Security Baseline |
| **Compliance Policy** | `CMP-W365-Standard` | `GRP-All-W365-Enterprise` | Excludes BitLocker |
| **Device Config** | `CFG-W365-Security-Baseline` | `GRP-All-W365-Enterprise` | Additional hardening |
| **Update Ring** | `UPD-W365-Pilot` | `GRP-IT-W365-Pilot` | 1 day deferral |
| **Update Ring** | `UPD-W365-Broad` | `GRP-All-W365-Enterprise` | 14 day deferral |
| **CA Policy** | `CA-101-RequireMFA-CloudPC` | `GRP-All-W365-Enterprise` | Require MFA |
| **CA Policy** | `CA-102-RequireCompliance-CloudPC` | `GRP-All-W365-Enterprise` | Require device compliance |
| **Filter** | `FLT-W365-Model-CloudPC` | — | `(device.model -contains "Cloud PC")` |

---

## 5. Graph Automation — Deploy It All

I've created a modular PowerShell automation using **Microsoft Graph** to deploy the baseline policies from the matrix above. The automation is split into independent modules that can be run individually or orchestrated together.

**Repository structure:**

```
W365-Baseline-Deployment/
├── Deploy-W365Baseline.ps1          # Orchestrator
├── modules/
│   ├── 01-Connect.ps1               # Authentication
│   ├── 02-Groups.ps1                # Entra ID groups
│   ├── 03-AssignmentFilters.ps1     # Intune assignment filters
│   ├── 04-CompliancePolicy.ps1      # Compliance policies
│   ├── 05-DeviceConfiguration.ps1   # Device configuration profiles
│   ├── 06-UpdateRings.ps1           # Windows Update rings
│   ├── 07-SecurityBaseline.ps1      # Security baseline (guidance)
│   └── 08-ConditionalAccess.ps1     # Conditional Access policies
└── config/
    └── baseline-config.json         # Central configuration file
```

> **Important:** The scripts create policies in **report-only** / **not assigned** mode by default. Review and assign manually after validation.

The deployment scripts will be published in a companion repository — follow on [LinkedIn](https://www.linkedin.com/in/ben-martin-baur/) or check [GitHub](https://github.com/benmartinbaur) for the release. Each module follows the naming convention defined in this post and can be customized via the central `baseline-config.json` configuration file.

> **Graph API throttling:** When running bulk policy creation, Microsoft Graph enforces per-app and per-tenant rate limits. Use `Retry-After` headers and exponential backoff. For bulk operations, batch requests using the Graph `$batch` endpoint (limit: 20 requests per batch).

---

## 6. Common Issues & Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| **Cloud PC name collision** | `%RAND%` generated a duplicate NetBIOS name | Increase RAND value (e.g., `%RAND:8%` gives 2.8 trillion combinations). Windows 365 auto-retries, but collisions delay provisioning |
| **Compliance shows "Not Evaluated"** | Multiple compliance policies with conflicting settings | When two policies target the same device with conflicting settings, Intune marks the setting as **Conflict** and neither applies. Use assignment filters and group targeting to avoid overlap. Check: Intune → Devices → Monitor → Assignment failures |
| **Dynamic group empty after creation** | Entra ID replication delay | Allow up to 24 hours for initial population. Check: Entra ID → Groups → [Group] → Audit logs for membership changes |
| **Security Baseline conflicts with Device Config** | Overlapping settings between `SBL-*` and `CFG-*` | Security Baselines take precedence over Device Configuration for the same setting. Avoid configuring the same CSP in both — use the baseline for security, config profiles for UX/network |
| **Scope tags not enforcing delegation** | Missing RBAC role assignment | Scope tags are metadata only until paired with an Intune RBAC role assignment. Configure: Intune → Tenant Admin → Roles → Create custom role → assign scope tags |
| **Provisioning policy fails in new region** | Entra ID replication lag | When creating groups and provisioning policies across regions, allow 5–15 minutes for Entra ID replication before assigning groups to provisioning policies in a different region |

---

## 7. Related Posts

- [Azure Default Outbound Access — What It Means for AVD & Windows 365](/posts/2026-03-13-azure-default-outbound-access-avd/) — If you're using Azure Network Connections (ANC), this covers the networking fundamentals for Cloud PC egress
- [Windows 365 for AI Agents — Why Cloud PCs Are the Enterprise Runtime for Agentic AI](/posts/2026-04-23-windows-365-for-ai-agents/) — Extending these naming conventions to agent Cloud PCs and automated workloads

---

## Sources & Further Reading

- [Windows 365 Planning Guide – Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/planning-guide)
- [Create Provisioning Policies – Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/create-provisioning-policy)
- [Cloud PC Lifecycle – Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/lifecycle)
- [Windows 365 Security Guidelines – Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/security-guidelines)
- [Deploy Security Baselines – Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/deploy-security-baselines)
- [Use Groups in Intune – Microsoft Learn](https://learn.microsoft.com/en-us/mem/intune/fundamentals/groups-add)
- [Assignment Filters in Intune – Microsoft Learn](https://learn.microsoft.com/en-us/mem/intune/fundamentals/filters)
- [Policy Sets in Intune – Microsoft Learn](https://learn.microsoft.com/en-us/mem/intune/fundamentals/policy-sets)

---

*What naming conventions do you use in your Intune environment? I'd love to hear what works for you — reach out on LinkedIn.*
