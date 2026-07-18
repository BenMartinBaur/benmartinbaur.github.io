# Windows 365: How to Enable AI-Enabled Cloud PCs (Computer Use Agents) in Your Tenant

This article walks you through every step needed to enable **AI-enabled Cloud PCs** — sometimes referred to as **Computer Use Agents (CUA)** — in your Windows 365 Enterprise tenant. AI-enabled Cloud PCs bring Copilot+ PC features like **Improved Windows Search** and **Click to Do** to your Cloud PCs, all processed securely in the cloud.

> **Status:** Frontier Public Preview (as of February 2026)
> **Important:** Future availability depends on the results of this [Frontier Preview](https://adoption.microsoft.com/copilot/frontier-program/) and is subject to change.

---

## What Are AI-Enabled Cloud PCs?

AI-enabled Cloud PCs extend Copilot+ PC capabilities to Windows 365 Enterprise Cloud PCs. Instead of requiring dedicated NPU hardware on a physical device, the AI processing happens in the Windows 365 cloud service — **ephemerally**, meaning no personal data is stored or used for AI model training.

**Supported features today:**

| Feature | Description |
|---|---|
| **Improved Windows Search** | Find files using descriptive, natural-language queries. Works across local and OneDrive files, searching by content — not just file names. |
| **Click to Do** | Press `Win + Q` or hold `Win` while left-clicking any element on screen to get contextual actions on highlighted text or images. |

---

## Prerequisites & Requirements

Before you start, make sure all of the following requirements are met.

### Licensing & Tenant

- **Windows 365 Enterprise** subscription
- **Microsoft Intune** admin access
- Users must be pre-registered with the **Windows Insider Program** before Cloud PC provisioning

### Cloud PC Specifications

| Requirement | Minimum |
|---|---|
| **SKU** | Windows 365 Enterprise — at least **8 vCPU, 32 GB RAM, 256 GB storage** |
| **OS Build (non-Insider)** | Windows 24H2 (>= 26100.6584) or 25H2 (>= 26200.6584) |
| **OS Build (Insider Beta)** | >= 26120.6682 |
| **Execution Policy** | `RemoteSigned` must be enabled on the Cloud PC |
| **Servicing Policy** | "Enable features introduced via servicing that are off by default" must be **Enabled** |

### Supported Regions

Your Cloud PC must be deployed in one of the following Azure regions:

- West US 2
- West US 3
- East US
- East US 2
- Central US
- Central India
- South East Asia
- Australia East
- UK South
- West Europe
- North Europe

---

## Step-by-Step: Enable AI-Enabled Cloud PCs

### Step 1: Register Users with the Windows Insider Program

Since the Frontier Preview is delivered through the Windows Insider Program, your users (and your organization) must be registered **before** provisioning.

1. Navigate to [https://www.microsoft.com/windowsinsider/](https://www.microsoft.com/windowsinsider/)
2. Sign in with the account associated with the target users
3. Register the organization for the Windows Insider Program

> **Docs Reference:** [About the Windows Insider Program](https://www.microsoft.com/windowsinsider/)

---

### Step 2: Assign AI-Enablement to Cloud PCs in Intune

This is the core configuration step — enabling the AI features for your targeted users and Cloud PCs.

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/)
2. Navigate to **Devices** > **Device onboarding** > **Windows 365**
3. Select the **Settings** tab
4. Click **Create**
5. Select **Cloud PC configurations** from the dropdown
6. Enter a **Name** (e.g., `AI-Enabled Cloud PCs`) and an optional **Description**
7. On the **Configuration settings** tab, set **AI-enabled features** to **Enable**
8. Follow the on-screen prompts to the **Assignments** tab
9. Select the **user groups** to target (remember: their Cloud PCs must meet all specifications above)
10. Proceed to **Review + create** and click **Create**

> **Wait up to 48 hours** for AI-enablement background processes to complete on targeted Cloud PCs.

---

### Step 3: Enroll Cloud PCs in the Windows Insider Beta Channel

AI-enabled features require the Windows Insider **Beta Channel** build. You have two options:

#### Option A: Bulk Enrollment via Intune (Recommended)

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/)
2. Navigate to **Devices** > **Windows** > **Update rings for Windows 10 and later**
3. Click **+ Create profile** (or edit an existing policy)
4. Under **Update ring settings**:
   - Set **Enable pre-release builds** to **Enable**
   - Set **Select pre-release channel** to **Beta Channel**
5. Under **Assignments**, select the groups containing your target Cloud PCs

> **Docs Reference:** [Managing preview builds across your organization](https://learn.microsoft.com/en-us/windows-insider/business/manage-builds)

#### Option B: Individual Cloud PC Enrollment (via Windows Settings)

1. On the Cloud PC, open **Settings** > **Windows Update**
2. Select **Windows Insider Program** > **Get started**
3. Sign in with the user account registered in the Windows Insider Program
4. Select the **Beta Channel**
5. Check for updates, install, and restart — **repeat 3–5 times** until no more pending updates

> **Tip:** If the Windows Insider Program option is not visible in Settings, set this registry key (requires admin):
>
> ```
> Registry Editor → HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility
> Create DWORD: HideInsiderPage = 0
> Restart the Cloud PC
> ```

---

### Step 4: Configure Cloud PC Prerequisites

On each target Cloud PC, two local settings must be configured:

#### 4a: Enable RemoteSigned Execution Policy

Open **PowerShell as Administrator** on the Cloud PC and run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 4b: Enable Servicing Features Policy

1. Open the **Local Group Policy Editor** (`gpedit.msc`)
2. Navigate to:
   **Computer Configuration** > **Administrative Templates** > **Windows Components** > **Windows Update** > **Manage end user experience**
3. Find **Enable features introduced via servicing that are off by default**
4. Right-click > **Edit** > Select **Enabled** > Click **Apply** > **OK**

After applying both settings:
1. Open **Settings** > **Windows Update**
2. Click **Check for updates**
3. Install all pending updates and **restart**

> **Repeat the update + restart cycle 3–5 times** until there are no more pending updates.

---

### Step 5: Wait for AI-Enablement to Complete

After assigning AI-enablement in Intune AND enrolling in the Insider Beta Channel, it can take **up to 48 hours** for background processes to finish setup.

After the wait period:
1. Check for Windows Updates again
2. Install any pending updates
3. Restart the Cloud PC
4. Repeat until no updates remain

---

## Validate AI-Enabled Status

Once the setup is complete, you can verify the AI-enabled state in multiple places:

### In Windows App

AI-enabled Cloud PCs show an **"AI-enabled" tag** on the device card within the Windows App.

### On the Cloud PC Taskbar

AI-enabled Cloud PCs display a **magnifying glass with sparkles icon** in the search box on the taskbar.

> **Note:** After a Windows Update, the sparkles icon may disappear temporarily. If clicking the search box doesn't restore it, see the [AI-enabled Cloud PC Known Issues](https://learn.microsoft.com/en-us/troubleshoot/windows-365/windows-365-ai-enabled-cloud-pc-known-issues) page.

### In Microsoft Intune

#### Device-Level Validation

1. Navigate to **Devices** > select the Cloud PC
2. On the **Overview** page, check the **Essentials** tab for the **"AI-enabled"** field

#### Tenant-Level Reporting

1. Navigate to **Reports** > **Cloud PC overview**
2. The report shows AI-enabled Cloud PCs grouped by status:
   - **Initiated** — Setup started
   - **Ready to use** — Setup completed, features available
   - **Failed** — Setup could not complete

---

## Manage Individual AI Features

If you want to keep AI-enablement active but configure specific features individually:

| Feature | Management |
|---|---|
| **Click to Do** | [Manage Click to Do for Windows clients](https://learn.microsoft.com/en-us/windows/client-management/manage-click-to-do) |
| **Improved Windows Search** | [Search Policy CSP](https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-search) |

> **Important:** You must launch the Click to Do app at least once after AI-enablement and after every Cloud PC restart before using the keyboard shortcut `Win + Q`.

---

## Remove AI-Enablement

If you need to disable AI features, there are two approaches:

### Option 1: Unassign User from Enable Policy

Simply remove the user group from the Cloud PC configuration that has AI-enabled features set to **Enable**.

### Option 2: Create a Disable Policy (Takes Precedence)

1. In Intune, navigate to **Devices** > **Device onboarding** > **Windows 365** > **Settings**
2. Click **Create** > **Cloud PC configurations**
3. Set **AI-enabled features** to **Disable**
4. Assign the target user groups
5. Click **Review + create** > **Create**

> The **Disable** policy takes precedence over the **Enable** policy during conflict resolution. Wait up to 48 hours for the change to take effect.

---

## Privacy & Security

AI-enabled Cloud PCs follow the same privacy standards as all Windows 365 Cloud PCs:

- **Data processing:** All AI processing is ephemeral — no personal data is stored in the cloud service or used for training AI models
- **Data storage:** All data and indexes remain stored on the Cloud PC itself
- **Customer controls:** AI features are **off by default** — IT admins must explicitly enable them

> **Docs Reference:** [Privacy and data in Windows 365](https://learn.microsoft.com/en-us/windows-365/enterprise/privacy-personal-data)

---

## Troubleshooting

| Issue | Resolution |
|---|---|
| Sparkles icon missing after update | See [AI-enabled Cloud PC Known Issues](https://learn.microsoft.com/en-us/troubleshoot/windows-365/windows-365-ai-enabled-cloud-pc-known-issues) |
| Features not available after 48h | Ensure OS Build meets minimum, check updates, restart 3–5 times |
| Windows Insider not visible in Settings | Set registry key `HideInsiderPage = 0` (see Step 3, Option B) |
| Click to Do not responding | Launch the Click to Do app manually at least once after enablement/restart |
| Cloud PC shows "Failed" in Intune reports | Verify region, SKU, OS Build, and Insider enrollment |

---

## Quick Reference: End-to-End Checklist

- [ ] Users registered with Windows Insider Program
- [ ] Cloud PCs meet minimum specs (8 vCPU / 32 GB RAM / 256 GB storage)
- [ ] Cloud PCs deployed in a supported Azure region
- [ ] AI-enablement assigned in Intune (Settings > Cloud PC configurations > Enable)
- [ ] Cloud PCs enrolled in Windows Insider Beta Channel
- [ ] RemoteSigned execution policy enabled on Cloud PCs
- [ ] "Enable features introduced via servicing" GPO enabled
- [ ] Windows Updates installed + restarted (3–5 cycles)
- [ ] Waited up to 48 hours for background setup
- [ ] Validated AI-enabled status (Windows App tag / taskbar sparkle icon / Intune)

---

## Resources

- [AI-enabled Cloud PC (Frontier Preview) | Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/ai-enabled-cloud-pcs)
- [Manage AI-enabled features (Frontier Preview) | Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/manage-ai-enabled-features)
- [AI-enabled Cloud PC Known Issues | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-365/windows-365-ai-enabled-cloud-pc-known-issues)
- [Windows Insider Program](https://www.microsoft.com/windowsinsider/)
- [Managing Preview Builds | Microsoft Learn](https://learn.microsoft.com/en-us/windows-insider/business/manage-builds)
- [Privacy and Data in Windows 365 | Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/privacy-personal-data)

---

*Posted February 27, 2026 in [Windows365](https://avdpunks.com/category/windows365/) by the AVDPunks crew*
*Tags: Windows365, AI-Enabled, Copilot+ PC, Cloud PC, Frontier Preview*
