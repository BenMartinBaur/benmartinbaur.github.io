# Windows Autopilot Device Preparation in Automatic Mode for Windows 365: The Complete Setup Guide

Windows Autopilot device preparation in automatic mode for Windows 365 ensures that **essential apps and scripts are installed on your Cloud PCs during provisioning** — before the user ever signs in. No custom images required. Instead of building and maintaining golden images with pre-installed applications, you define what gets installed through Intune policies, and Windows Autopilot device preparation handles the rest.

The Cloud PC status transitions from **Provisioning** → **Preparing** (Autopilot device prep is running) → **Provisioned** (ready for use). IT admins get full visibility into which apps and scripts succeeded, failed, or were skipped.

> **Status:** Public Preview (as of February 2026)
> **Applies to:** Windows 11
> **Supported SKUs:** Windows 365 Enterprise, Windows 365 Frontline (shared & dedicated), Windows 365 Cloud Apps

---

## What Happens Under the Hood?

Here's the automated process flow when a Cloud PC is provisioned with device preparation:

1. Windows 365 Cloud PC agent **creates** the Cloud PC
2. Cloud PC agent **joins Microsoft Entra**
3. Cloud PC agent triggers **Intune enrollment**
4. Cloud PC agent calls the **Autopilot device preparation policy** assigned to the provisioning policy
5. **Intune Management Extension** is installed
6. Deployment **syncs with Intune** and checks for LOB/Microsoft 365 apps in the policy
7. **LOB and Microsoft 365 apps** are installed (if selected)
8. **PowerShell scripts** run (if selected)
9. **Win32, Microsoft Store, and Enterprise App Catalog apps** are installed (if selected)

**Limits during device preparation:**

| Resource | Maximum |
|---|---|
| Applications | **25** managed apps |
| PowerShell scripts | **10** scripts |

> All apps and scripts run in **System context** since no user is signed in during OOBE.

---

## Prerequisites

| Requirement | Details |
|---|---|
| **Windows 365 license** | Enterprise, Frontline (shared/dedicated), or Cloud Apps |
| **Microsoft Intune** | Admin access required |
| **Microsoft Entra ID** | Automatic MDM enrollment configured |
| **Windows version** | [Supported version of Windows 11](https://learn.microsoft.com/en-us/autopilot/device-preparation/requirements#windows-365-cloud-pcs) |
| **Join type** | Microsoft Entra Join (required) |
| **Network** | Microsoft hosted network or Azure network connection |

---

## Step-by-Step: Full 6-Step Workflow

### Step 1: Set Up Windows Automatic Intune Enrollment

Devices need to enroll in Intune automatically for Autopilot device preparation to work.

1. Sign in to the [Azure portal](https://portal.azure.com/)
2. Select **Microsoft Entra ID**
3. Under **Manage**, select **Mobility (MDM and WIP)**
4. Select **Microsoft Intune**
5. Under **MDM user scope**, select one of:

| Option | Effect |
|---|---|
| **All** | All users can automatically enroll their devices in Intune |
| **Some** | Only users in the specified groups can auto-enroll. Click the **Groups** link to select the Microsoft Entra user groups. |

6. Click **Save**

> **Note:** If automatic Intune enrollment is already configured in your tenant, skip to Step 2.

> **Docs Reference:** [Set up Windows automatic Intune enrollment](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-automatic-enrollment)

---

### Step 2: Create an Assigned Device Group

Windows Autopilot device preparation requires an **assigned** security device group (not dynamic). Devices are automatically added to this group during the deployment process.

> **Best Practice:** Create a **separate** assigned device group for each Autopilot device preparation policy. Don't reuse groups from other Autopilot scenarios.

#### 2a) Create the Group

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/)
2. Select **Groups** in the left pane
3. Click **New group**
4. Configure the group:

| Setting | Value |
|---|---|
| **Group type** | Security |
| **Group name** | e.g., `APDP-W365-DeviceGroup` |
| **Group description** | e.g., `Assigned device group for Autopilot Device Preparation - Windows 365` |
| **Microsoft Entra roles can be assigned to the group** | No |
| **Membership type** | **Assigned** |

5. Under **Owners**, click **No owners selected**
6. In the **Add owners** pane, search for **Intune Provisioning Client**
   - The AppId is `f1346770-5b25-470b-88bd-d5744ab7952c`
   - In some tenants, this service principal is named **Intune Autopilot ConfidentialClient** — as long as the AppId matches, it's the correct one

7. Select the service principal and click **Select**
8. Click **Create**

> **Important:** You do NOT need to manually add devices to this group. Devices are added automatically during provisioning.

#### 2b) Adding the Intune Provisioning Client Service Principal (if missing)

If the **Intune Provisioning Client** service principal doesn't appear when searching for group owners, you need to create it via PowerShell.

Open an **elevated PowerShell** window on a device where you administer Intune/Entra ID:

```powershell
# Step 1: Install required modules
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser
Install-Module Microsoft.Graph.Applications -Scope CurrentUser

# Step 2: Connect to Microsoft Entra ID with required scope
Connect-MgGraph -Scopes "Application.ReadWrite.All"
```

> **Note:** A browser window opens for authentication. Sign in with a Microsoft Entra ID administrator account. If a **Permissions requested** window appears, check **"Consent on behalf of your organization"** and click **Accept**.

```powershell
# Step 3: Create the service principal
New-MgServicePrincipal -AppID f1346770-5b25-470b-88bd-d5744ab7952c
```

**Common errors:**

| Error | Meaning |
|---|---|
| `Request_MultipleObjectsWithSameKeyValue` (409 Conflict) | The service principal **already exists** in your tenant. You're good — go back and search for it in the group owners. |
| `Authorization_RequestDenied` (403 Forbidden) | The account doesn't have permissions, the `-Scopes` argument is missing, or you didn't accept/consent the permissions request. |

> **Docs Reference:** [Create an assigned device group](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-device-group)

---

### Step 3: Assign Applications and PowerShell Scripts to the Device Group

Before the apps and scripts can be used during device preparation, they must be **assigned to the device group** created in Step 2.

> **Note:** The apps/scripts must already exist in Intune. If not, add them first via [Add apps to Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune-service/apps/apps-add).

#### 3a) Assign Applications

**Supported app types:**

| App Type | Supported |
|---|---|
| Line-of-business (LOB) | Yes |
| Win32 | Yes |
| Microsoft Store (WinGet-supported) | Yes |
| Microsoft 365 | Yes |
| Enterprise App Catalog | Yes |

> Win32 and LOB apps can be deployed together in the same deployment.

**Steps:**

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/)
2. Select **Apps** > **Windows** (under By platform)
3. Select the desired application
4. Under **Manage**, select **Properties**
5. Next to **Assignments**, click **Edit**
6. Under **Required**, click **Add group**
7. Search for and select your Autopilot device preparation device group (e.g., `APDP-W365-DeviceGroup`)
8. Click **Select**
9. Verify:
   - Group is listed under **Required**
   - **Group mode** is set to **Included**
   - **Install Context** is set to **Device context** (when applicable)
10. Click **Review + save** > **Save**
11. Repeat for all additional apps

#### 3b) Assign PowerShell Scripts

1. In Intune, select **Devices** > **Manage devices** > **Scripts and remediations**
2. Select **Platform scripts**
3. Select the desired PowerShell script
4. Under **Manage**, select **Properties**
5. Next to **Assignments**, click **Edit**
6. Under **Included groups**, click **Add groups**
7. Search for and select your device group
8. Click **Select**
9. Verify the group is under **Included groups** (not **Excluded groups**)
10. Click **Review + save** > **Save**

> **Important:** All apps and scripts must be configured to run in **System context** since they execute during OOBE when no user is signed in. For PowerShell scripts, set **"Run this script using the logged on credentials"** to **No**.

> **Docs Reference:** [Assign applications and PowerShell scripts to device group](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-assign-apps-scripts)

---

### Step 4: Create the Windows Autopilot Device Preparation Policy

This is the core policy that defines what gets installed during device preparation.

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/)
2. Select **Devices** > **Windows** (under By platform)
3. Under **Device onboarding**, select **Enrollment**
4. Under **Windows Autopilot device preparation**, select **Device preparation policies**
5. Click **Create** > **Automatic (Preview)**
6. **Introduction** page: Click **Next**

7. **Basics** page:

| Field | Value |
|---|---|
| **Name** | e.g., `APDP-W365-AutomaticMode` |
| **Description** | e.g., `Autopilot Device Preparation policy for Windows 365 automatic mode provisioning` |

   Click **Next**

8. **Device group** page:
   - Search for and select the device group created in Step 2 (e.g., `APDP-W365-DeviceGroup`)
   - Click **Next**

9. **Configuration settings** page:

   **Apps section:**
   - Click **Add** to open the Select Apps pane
   - Search for and select the essential apps (up to 10 in the policy)
   - Click **Save**
   - All selected apps appear under **Allowed Applications**

   **Scripts section:**
   - Click **Add** to open the Select Scripts pane
   - Search for and select the essential PowerShell scripts (up to 10 in the policy)
   - Click **Save**
   - All selected scripts appear under **Allowed Scripts**

   > **Important:** Apps selected here **must also be assigned** to the device group from Step 3. Apps must be configured for **System context** installation.

   Click **Next**

10. **Scope tags** page: Click **Next** (optional — configure if your org uses scope tags)

11. **Review + create** page: Review all settings and click **Save**

> **Note:** There is **no Assignments page** for automatic mode policies. The assignment happens via the Cloud PC provisioning policy in Step 5.

> **Docs Reference:** [Create Windows Autopilot device preparation policy](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-autopilot-policy)

---

### Step 5: Create a Cloud PC Provisioning Policy

This is where you link the Autopilot device preparation policy to your Windows 365 provisioning.

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/)
2. Select **Devices** > **Windows 365** (under Device onboarding)
3. Select **Provisioning policies** > **Create policy**

4. **General** page:

| Setting | Value |
|---|---|
| **Name** | e.g., `W365-APDP-Provisioning` |
| **Description** | e.g., `Windows 365 provisioning policy with Autopilot Device Preparation` |
| **Experience** | Access a full Cloud PC desktop |
| **License type** | Choose based on your SKU (Enterprise, Frontline, etc.) |
| **Frontline type** (if applicable) | Shared or Dedicated |
| **Join type** | **Microsoft Entra Join** |
| **Network** | **Microsoft hosted network** |
| **Geography/Region** | Select as appropriate |
| **Microsoft Entra single sign-on** | Enable if desired |

   Click **Next**

5. **Image** page:
   - Ensure a [supported Windows version](https://learn.microsoft.com/en-us/autopilot/device-preparation/requirements#windows-365-cloud-pcs) is selected
   - Click **Change** to select a different gallery image or custom image
   - Click **Next**

   > **Tip:** Gallery images come pre-installed with the latest Windows updates.

6. **Configuration** page:

| Setting | Value |
|---|---|
| **Language & Region** | Select via dropdown |
| **Cloud PC naming** | (Optional) Toggle **Apply device name template** and define a naming pattern |

   Under **Windows Autopilot (Preview)**:

| Setting | Value |
|---|---|
| **Autopilot Device preparation policy** | Select the policy created in Step 4 (e.g., `APDP-W365-AutomaticMode`) |
| **Minutes allowed before device preparation fails** | Enter a value between **10–360** (recommended **minimum 30**, e.g., `60`) |
| **Prevent users from connection to Cloud PC upon installation failure or timeout** | **Checked** = Failed deployments are marked "Failed" and blocked. **Unchecked** = Failed deployments are marked "Provisioned with warnings" and users can still connect. |

   Click **Next**

7. **Scope tags** page: Click **Next** (optional)

8. **Assignments** page:
   - Click **Add groups** and select the **user group** to assign the Cloud PCs to
   - Next to the group, click **Select one** under **Cloud PC size**
   - In the **Select Cloud PC size** pane:
     - Select the desired Cloud PC configuration from the **Available Cloud PCs** dropdown
     - Enter a **Name** for the assignment
     - Enter the number of Cloud PCs under **Remaining Cloud PCs** (0–900)
   - Click **Select**
   - Click **Next**

9. **Review + create** page: Review all settings and click **Create**

> **Docs Reference:** [Create a Cloud PC provisioning policy](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-cloud-pc-provisioning-policy)

---

### Step 6: Monitor the Deployment

Since automatic mode provisioning happens in the background (no visible OOBE on screen), monitoring is done entirely through the Intune admin center.

#### View Overall Status

1. Sign in to the [Microsoft Intune admin center](https://intune.microsoft.com/)
2. Select **Devices** > **Windows 365** (under Device onboarding)
3. Select **All Cloud PCs**
4. Check the **Status** column:

| Status | Meaning |
|---|---|
| **Provisioning** | Cloud PC is being created, not ready yet |
| **Preparing** | Autopilot device preparation is running (installing apps/scripts) |
| **Provisioned** | Successfully provisioned and ready for use |
| **Failed** | Provisioning failed and user is blocked (if "prevent connection" is enabled) |
| **Provisioned with warnings** | Failed but user can still connect (if "prevent connection" is disabled) |

> **Tip:** Filter Cloud PCs by status using the status filter above the table.

#### View Granular Status (Per App/Script)

1. In Intune, select **Devices** > **Monitor**
2. Under **Report name**, select **Windows Autopilot device preparation deployments**
3. View per-device deployment details:

| Column | Details |
|---|---|
| **Device name** | Click to see deployment details |
| **Enrollment date** | Date and time of enrollment |
| **Deployment status** | In progress, Success, or Failed |
| **Phase** | Policy installation, Script installation, or App installation |
| **Deployment time** | Duration of the OOBE deployment |

4. Click an individual device to see detailed status in three sections:
   - **Device** — Device info, deployment policy, policy version, OS version
   - **Apps** — Status per application: Installed, In progress, Skipped, or Failed
   - **Scripts** — Status per script: Installed, In progress, Skipped, or Failed

> **Important:** Reprovisioned Windows 365 devices after a failed deployment remain in the Autopilot report for diagnostic log access. Use [Intune cleanup rules](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/device-cleanup-rules) or delete manually to clean up stale records.

> **Known Issue:** Win32, Microsoft Store, and Enterprise App Catalog apps may be **skipped** when a managed installer is configured. See [known issues](https://learn.microsoft.com/en-us/autopilot/device-preparation/known-issues).

> **Docs Reference:** [Monitor the deployment](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-monitor)

---

## Quick PowerShell Reference: Service Principal Setup

Here's the complete PowerShell block to add the Intune Provisioning Client service principal to your tenant:

```powershell
#Requires -Version 5.1

# ============================================================
# Add Intune Provisioning Client Service Principal
# Required for Windows Autopilot Device Preparation
# ============================================================

# Install required Graph modules
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Applications -Scope CurrentUser -Force

# Connect to Microsoft Entra ID
# A browser window will open for authentication
Connect-MgGraph -Scopes "Application.ReadWrite.All"

# Create the Intune Provisioning Client service principal
# AppId: f1346770-5b25-470b-88bd-d5744ab7952c
try {
    $sp = New-MgServicePrincipal -AppID "f1346770-5b25-470b-88bd-d5744ab7952c"
    Write-Host "Service principal created successfully!" -ForegroundColor Green
    Write-Host "Display Name: $($sp.DisplayName)" -ForegroundColor Green
    Write-Host "Object ID: $($sp.Id)" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -match "already in use") {
        Write-Host "Service principal already exists in your tenant — no action needed." -ForegroundColor Yellow
        
        # Retrieve existing service principal
        $existingSp = Get-MgServicePrincipal -Filter "appId eq 'f1346770-5b25-470b-88bd-d5744ab7952c'"
        Write-Host "Display Name: $($existingSp.DisplayName)" -ForegroundColor Yellow
        Write-Host "Object ID: $($existingSp.Id)" -ForegroundColor Yellow
    } else {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Disconnect when done
Disconnect-MgGraph
```

---

## End-to-End Checklist

Use this checklist to verify you haven't missed anything:

- [ ] **Step 1:** Windows automatic Intune enrollment configured (MDM user scope set to All or Some)
- [ ] **Step 2a:** Assigned security device group created
- [ ] **Step 2b:** Intune Provisioning Client (`f1346770-5b25-470b-88bd-d5744ab7952c`) set as group **Owner**
- [ ] **Step 2b (if needed):** Service principal created via `New-MgServicePrincipal` PowerShell command
- [ ] **Step 3a:** All required apps assigned to the device group as **Required** with **Device context**
- [ ] **Step 3b:** All required PowerShell scripts assigned to the device group with **System context** (Run as logged-on: No)
- [ ] **Step 4:** Autopilot device preparation policy created in **Automatic (Preview)** mode
- [ ] **Step 4:** Correct device group selected in the policy
- [ ] **Step 4:** Essential apps and scripts added to the policy configuration
- [ ] **Step 5:** Cloud PC provisioning policy created with the Autopilot device preparation policy linked
- [ ] **Step 5:** Timeout value set (minimum 30 minutes recommended)
- [ ] **Step 5:** Failure behavior configured (prevent connection or allow with warnings)
- [ ] **Step 5:** User group assigned with appropriate Cloud PC size
- [ ] **Step 6:** Monitoring configured — check deployment status in Intune

---

## Troubleshooting

| Issue | Solution |
|---|---|
| Intune Provisioning Client not found in group owners | Run the PowerShell script from the [Service Principal Setup](#quick-powershell-reference-service-principal-setup) section |
| Service principal error: `Authorization_RequestDenied` | Sign in with an Entra ID admin account, include `-Scopes "Application.ReadWrite.All"`, and accept the consent prompt |
| Apps show "Skipped" in deployment report | Verify apps are **assigned to the device group** (Step 3) AND **added to the policy** (Step 4). Also check the [managed installer known issue](https://learn.microsoft.com/en-us/autopilot/device-preparation/known-issues) |
| Deployment stuck on "Preparing" | Check if apps/scripts are timing out. Increase the timeout value in the provisioning policy (Step 5) |
| Deployment shows "Failed" | Use the granular monitoring (Step 6) to check which phase failed: Policy, Script, or App installation |
| Cloud PC shows "Provisioned with warnings" | Some apps/scripts failed but the "prevent connection" option was unchecked. Review the detailed deployment report. |
| PowerShell scripts fail during deployment | Ensure scripts are configured with **"Run this script using the logged on credentials"** set to **No** (System context) |
| Dynamic group used instead of assigned | Autopilot device preparation **only** supports assigned groups. Recreate as an assigned security group. |

---

## Resources

| Resource | Link |
|---|---|
| **Tutorial Overview** | [Windows Autopilot device preparation in automatic mode for Windows 365](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-workflow) |
| **Step 1: Intune Enrollment** | [Set up Windows automatic Intune enrollment](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-automatic-enrollment) |
| **Step 2: Device Group** | [Create an assigned device group](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-device-group) |
| **Step 3: Assign Apps/Scripts** | [Assign applications and PowerShell scripts](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-assign-apps-scripts) |
| **Step 4: Device Prep Policy** | [Create Windows Autopilot device preparation policy](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-autopilot-policy) |
| **Step 5: Cloud PC Policy** | [Create a Cloud PC provisioning policy](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-cloud-pc-provisioning-policy) |
| **Step 6: Monitoring** | [Monitor the deployment](https://learn.microsoft.com/en-us/autopilot/device-preparation/tutorial/automatic/automatic-monitor) |
| **Reporting & Monitoring** | [Autopilot device preparation reporting](https://learn.microsoft.com/en-us/autopilot/device-preparation/reporting-monitoring) |
| **Known Issues** | [Autopilot device preparation known issues](https://learn.microsoft.com/en-us/autopilot/device-preparation/known-issues) |
| **Requirements** | [Autopilot device preparation requirements](https://learn.microsoft.com/en-us/autopilot/device-preparation/requirements) |
| **Add Apps to Intune** | [Add apps to Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune-service/apps/apps-add) |
| **PowerShell Scripts in Intune** | [Use PowerShell scripts on Windows devices](https://learn.microsoft.com/en-us/mem/intune-service/apps/intune-management-extension) |

---

*Posted on February 27, 2026 | Tags: Windows Autopilot, Device Preparation, Windows 365, Intune, Cloud PC, Automatic Mode, Provisioning, Entra ID*
