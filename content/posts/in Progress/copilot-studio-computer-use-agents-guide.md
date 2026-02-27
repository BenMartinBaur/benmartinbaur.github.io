# Copilot Studio Computer Use Agents: AI That Actually Clicks Your Buttons

Computer Use is a preview tool in **Microsoft Copilot Studio** that lets your agent interact with websites and desktop apps — clicking buttons, filling forms, and navigating UIs — all driven by natural language instructions. No API integration required. No code. If a human can do it on screen, Computer Use can too.

Under the hood, it's powered by **Computer-Using Agents (CUA)** — an AI model that combines vision with reasoning. It sees screenshots, understands what's on screen, and performs actions via virtual mouse and keyboard. Unlike traditional RPA that breaks when a UI changes, CUA adapts — it finds the submit button wherever it moved.

> **Status:** Preview (as of February 2026)
> **Important:** Preview features aren't meant for production use and may have restricted functionality. This is early-access technology — experiment, evaluate, and [provide feedback](https://community.powerplatform.com/forums/thread/?groupid=db8f53c2-767d-47d6-a1ae-fe4c828a6553).

---

## What Can Computer Use Do?

Computer Use follows an iterative loop:

1. **Perception** — Captures screenshots to understand the current screen state
2. **Reasoning** — Evaluates the current state, previous actions, and screenshots through chain-of-thought reasoning
3. **Action** — Performs actions like clicking, typing, or scrolling until the task is complete

**Example use cases:**

| Scenario | Description |
|---|---|
| **Data Entry** | Submitting inventory items to a web-based form |
| **Invoice Processing** | Extracting data from a PDF and filling it into another system |
| **Data Extraction** | Looking up portfolio values and returning structured JSON |
| **Legacy App Automation** | Interacting with vendor portals or ERP systems that have no API |
| **Compliance & Timesheets** | Filling repetitive forms that change layouts frequently |

---

## Prerequisites & Requirements

Before you start, make sure the following requirements are met.

### Environment & Licensing

| Requirement | Details |
|---|---|
| **Copilot Studio Access** | A valid Microsoft Copilot Studio license or trial |
| **Environment Region** | Power Platform environment must be set to **United States** (preview limitation) |
| **Dataverse** | Required — your environment must have a Dataverse data store |
| **Copilot Credits** | Computer Use consumes **5 Copilot Credits per step** (billed as Agent action) |
| **External Models (optional)** | If you want to use Anthropic Claude Sonnet 4.5, your admin must enable external models |

### Supported AI Models

| Provider | Model | Status | Human Supervision |
|---|---|---|---|
| Azure OpenAI | Computer-Using Agent (CUA) | Active | Yes |
| Anthropic | Claude Sonnet 4.5 | Active (rolling out) | Yes |

> **Note:** Anthropic's Claude Sonnet 4.5 is currently rolling out across supported regions and may not yet be available in your environment. Ensure your administrator has [enabled external models](https://learn.microsoft.com/en-us/power-platform/admin/allow-llm-generative-responses).

### Machine Options

Computer Use needs a Windows machine to run on. You have three options:

| Option | Best For | Details |
|---|---|---|
| **Hosted Browser** | Quick testing & demos | Microsoft-managed, no setup required. Not for production — may be throttled. |
| **Cloud PC Pool** | Scalable production workloads | Powered by Windows 365 for Agents. Entra-joined, Intune-enrolled, auto-scaling. |
| **Bring-Your-Own-Machine** | Full control | Your own Windows machine with Power Automate for desktop v2.61.132.25266+. |

---

## Step-by-Step: Enable Computer Use Agents

### Step 1: Create a US-Region Power Platform Environment

Computer Use is currently **only available in US-region environments**. If your tenant isn't in the US, that's fine — you just need a Power Platform environment set to the US region.

1. Go to [https://admin.powerplatform.microsoft.com](https://admin.powerplatform.microsoft.com)
2. Navigate to **Manage** > **Environments** > **+ New**
3. Configure the environment:

| Setting | Recommended Value |
|---|---|
| **Name** | Something descriptive, e.g., `CUA-Preview-US` |
| **Region** | **United States** (required for Computer Use preview) |
| **Managed Environment** | No (for demo/testing) — Yes for governed production environments |
| **Type** | Choose based on your needs (Developer, Sandbox, or Production) |
| **Dataverse data store** | **Yes** (required for Copilot Studio) |
| **Pay-as-you-go with Azure** | Optional, depends on your licensing |

4. On the security group page, assign a security group or choose **None** for demo purposes
5. Click **Done** and wait for the environment to be provisioned

> **Docs Reference:** [Power Platform Admin Center — Environments](https://learn.microsoft.com/en-us/power-platform/admin/environments-overview)

---

### Step 2: (Optional) Enable External AI Models

If you want to use **Anthropic's Claude Sonnet 4.5** as the Computer Use model, you need to enable external models at two levels.

#### A) Microsoft 365 Admin Center

1. Allow [Anthropic access in the Microsoft 365 admin center](https://go.microsoft.com/fwlink/?linkid=2341952)
2. (Optional) Allow [xAI access in the Microsoft 365 admin center](https://go.microsoft.com/fwlink/?linkid=2348423)

#### B) Power Platform Admin Center

1. Sign in to the [Power Platform admin center](https://admin.powerplatform.microsoft.com/)
2. Navigate to **Manage** > **Environments** > Select your US environment
3. Click **Settings** in the command bar
4. Go to **Product** > **Features**
5. Check the **Anthropic** model family toggle to **On**
6. Click **Save**

> **Important:** If the toggle is visible but greyed out, your organization admin hasn't enabled Anthropic access in the Microsoft 365 admin center yet (Step A).

> **Note:** Anthropic models in Copilot Studio are currently excluded from EU Data Boundary commitments. FedRAMP isn't achieved for Anthropic models. Consult with your authorization official if these compliance frameworks apply to your organization.

> **Docs Reference:** [Allow external language models for generative responses](https://learn.microsoft.com/en-us/power-platform/admin/allow-llm-generative-responses)

---

### Step 3: Open Copilot Studio and Select Your US Environment

1. Navigate to [https://copilotstudio.microsoft.com](https://copilotstudio.microsoft.com/)
2. In the **top right corner**, click the environment dropdown
3. Select your **US-region environment** (e.g., `CUA-Preview-US`)

> **Tip:** If you don't see your environment in the dropdown, make sure the Dataverse provisioning has completed.

---

### Step 4: Create a New Agent

1. In Copilot Studio, go to **Agents** > **+ New agent**
2. Click **Configure** (next to "Describe")
3. Fill in:

| Field | Value |
|---|---|
| **Name** | e.g., `Computer Use Agent Demo` |
| **Description** | e.g., `Demo agent for Computer Use — automates web and desktop tasks` |

4. Click **Create**

> **Tip:** Newly created agents use **generative orchestration** by default, which is required for Computer Use. If you're using an existing agent, verify it's enabled: **Settings** > **Generative AI** > **Orchestration** > **Yes**.

---

### Step 5: Add Computer Use as a Tool

This is the core step — adding the Computer Use capability to your agent.

1. On your agent page, scroll down to **Tools** and click **Add tool**
   - Alternatively, select **Tools** from the left menu
2. In the **Add tool** dialog, click **New tool**
3. Select **Computer use**
4. **Write your instructions** — describe the task in natural language, step-by-step

#### Example Instructions (Microsoft's "Bike Parts" Demo)

```text
1. Go to https://computerusedemos.blob.core.windows.net/web/Adventure/index.html
2. Submit a new entry for each of the following items:
   Rear Derailleur, RD-4821, 50, 42.75, Tailspin Toys
   Pedal Set, PD-1738, 80, 19.99, Northwind Traders
   Brake Lever, BL-2975, 35, 14.50, Trey Research
   Chainring Bolt Set, CB-6640, 100, 5.25, VanArsdel, Ltd.
   Bottom Bracket, BB-9320, 60, 24.90, Tailwind Traders
```

5. Click **Add and Configure**

---

### Step 6: Configure the Computer Use Tool

On the configuration page, fill in the following fields:

| Field | Description |
|---|---|
| **Name** | Display name to differentiate from other tools, e.g., `Submit inventory items` |
| **Description** | What this tool does and when to use it, e.g., `Add products to the inventory system.` |
| **Model** | Choose between **OpenAI Computer-Using Agent (CUA)** or **Anthropic Claude Sonnet 4.5** |
| **Instructions** | The step-by-step natural language instructions (entered in Step 5) |

#### Machine Selection

- **Use hosted browser** is selected by default — this uses a Microsoft-managed Windows 365 machine for quick testing
- Use **Refresh** to update the machine list
- Choose **Manage machines** to open the Power Automate machine management portal

#### Credentials Configuration

Specify how Computer Use authenticates during execution:

| Option | Use Case |
|---|---|
| **Maker-provided credentials** (default) | Uses the maker's credentials. Suitable for autonomous agents. **Warning:** Anyone you share the agent with can act with your access on the configured machine. |
| **End user credentials** | Uses the credentials of the person interacting with the agent. Each user needs machine access. |

#### Stored Credentials (for website/app sign-ins)

If Computer Use encounters a login prompt, it can use pre-configured credentials. Storage options:

| Storage | Details |
|---|---|
| **Internal storage** | No preconfiguration needed. Secrets encrypted and stored in Power Platform. Provide: Type (Website/Desktop app), Username, Password, Login domain or app name. |
| **Azure Key Vault** | Provide Subscription ID, Resource Group, Key Vault name, Username, Azure secret name, Login domain. Requires PowerPlatform resource provider registration on the subscription. |

> **Note:** Password fields are supported on all websites and most Windows applications (WinForms, WPF, UWP, WinUI, Win32). Electron, Java, Unity, games, CLI, Citrix, or virtualized environments may not be supported.

#### Access Control

By default, Computer Use can operate on **any website or application**. To restrict access:

1. Enable **Access control** on the configuration page
2. Add allowed **Websites** (e.g., `www.contoso.com`, `*.contoso.com`)
3. Add allowed **Desktop applications** by product name or process name (e.g., `Microsoft Edge`, `msedge`, `Notepad`)

> **Important:** Access control prevents the model from **taking actions** on unlisted sites/apps, but doesn't stop it from **opening** them. For example, it could still use the Edge search bar to navigate to Bing, but any interaction with Bing would be blocked.

#### Human Supervision

Configure who should be contacted if the agent detects potentially harmful instructions:

1. Specify a reviewer email (Outlook) in the **Human supervision** section
2. Set the **response time limit** — defines how long the request stays active before expiring
3. Reviewers can respond via email or within Copilot Studio's activity map

| Model | Human Supervision Supported |
|---|---|
| OpenAI Computer-Using Agent (CUA) | Yes |
| Anthropic Claude Sonnet 4.5 | Yes |

> **Docs Reference:** [Human supervision of computer use](https://learn.microsoft.com/en-us/microsoft-copilot-studio/human-supervision-computer-use)

7. Click **Save**

---

### Step 7: Test Your Agent

1. Back on the agent **Overview** page, open the **Test** panel
2. Send a message to trigger the Computer Use tool
3. The test experience shows:
   - **Left panel:** Instructions and a step-by-step log of reasoning and actions
   - **Right panel:** Live preview of actions on the configured machine
4. When the task finishes, you see a **Test completed** message
5. Select **Stop testing** at any time to immediately halt all actions

> **Tip:** If results aren't what you expect, go back to the configuration page and refine your instructions. Add more detail to improve accuracy. Check the [best practices for writing instructions](#best-practices-for-writing-instructions) section below.

6. Go to **Activity** to see your agent's execution history

---

### Step 8: Publish Your Agent

Once you're satisfied with testing:

1. Click **Publish** on your agent
2. Choose your deployment scenario:

| Scenario | Description |
|---|---|
| **Autonomous agent** | Runs automatically in the background, no user interaction needed. **Recommended for Computer Use.** |
| **Conversational agent** | Users interact through channels like Microsoft Teams. Screenshots and reasoning are shared in chat. |

> **Note:** For conversational agents with **User authentication**, each user needs valid credentials for the Computer Use machine.

---

## (Optional) Bring-Your-Own-Machine Setup

For production use, the hosted browser isn't recommended (it may be throttled). Set up your own machine:

### Register a Machine

1. Install [Power Automate for desktop](https://learn.microsoft.com/en-us/power-automate/desktop-flows/install) **v2.61.132.25266 or later**
   - During installation, check **"Install the machine-runtime app to connect to the Power Automate cloud portal"**
   - Include the **Power Automate web extension** for browser interactions
2. Open the **Power Automate machine runtime app** and sign in
3. Register the machine to your **US-region environment**

### Enable Computer Use on the Machine

1. Sign in to [Power Automate](https://make.powerautomate.com/)
2. Go to **Machines**
3. Select your registered machine
4. Click **Settings**
5. Toggle **Enable for computer use** to **On**
6. Click **Save**

### Connect the Machine in Copilot Studio

1. In your Agent, go to **Tools** > **Machines**
2. Click the **three dots** next to machines to change your agent's host
3. Click the **three dots** for Computer Use and select **Add new connection**
4. Enter the machine credentials
5. Re-test your agent — it now runs on your own machine

> **Docs Reference:** [Configure where computer use runs](https://learn.microsoft.com/en-us/microsoft-copilot-studio/configure-where-computer-use-runs)

---

## (Optional) Cloud PC Pool Setup

Cloud PC pools, powered by **Windows 365 for Agents**, provide scalable, secure compute without bringing your own machines.

**Key features:**

- Auto-scaling Cloud PCs based on current workloads
- Work or school account integration (Microsoft 365, SharePoint, Azure)
- Entra-joined and Intune-enrolled for full governance
- Organization policy compliance

> **Docs Reference:** [Use Cloud PC pool for computer use runs](https://go.microsoft.com/fwlink/?linkid=2336065)

---

## Best Practices for Writing Instructions

Clear instructions are **everything**. Think of it as explaining a task to a colleague who's never used the application before.

| Tip | Example |
|---|---|
| **Be specific about URLs and apps** | `Open https://www.microsoft.com and go to 'Company news'` |
| **State actions explicitly** | `Once you fill in the form, select Submit. No need to ask for permission.` |
| **Break down complex UIs** | `Select the More icon in the top right corner. A dropdown appears. Once it opens, select the last item in the list.` |
| **Use step-by-step format** | Number your instructions for longer tasks |
| **Use Inputs for dynamic values** | Create input parameters for values that change per run |

### Data Extraction Tips

You can instruct Computer Use to extract data and return it as **plain text** or **structured JSON**:

**Plain text example:**

```text
1. Go to https://computerusedemos.blob.core.windows.net/web/Portfolio/index.html
2. Find the row for Fourth Coffee and record the Portfolio Manager name and the current Portfolio Value exactly as shown.
3. Return those two values as the final output.
```

**JSON example:**

```text
Navigate to https://computerusedemos.blob.core.windows.net/web/Portfolio/index.html, retrieve the portfolio details for all Contoso entities, and return the results as a valid JSON object.

Structure the output so that:
*  Each top-level key is the client name
*  Each value contains the client's portfolio ID, portfolio value, portfolio manager, and last updated date (format: YYYY-MM-DD)
*  Return only the JSON, with no additional text.
```

---

## Security Best Practices

Giving an AI control of a Windows desktop is powerful — and risky. These mitigations are **non-negotiable** for anything beyond demo purposes.

| Recommendation | Details |
|---|---|
| **Use dedicated machines** | Assign isolated machines exclusively for Computer Use tasks. Reduces cross-contamination risk. |
| **Least-privilege accounts** | Grant only the permissions needed to run the required tools. No admin rights. |
| **Restrict web access** | Allow only a predefined list of trusted domains. Configure [Microsoft Edge policies via Intune](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies). |
| **Limit desktop apps** | Only install and allow execution of essential applications. Use [Application Control](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/wdac) (WDAC). |
| **Intune Security Baseline** | Apply security baselines to lock down the machine |
| **Edge Security Baseline** | Lock down Edge to only allow defined websites |
| **Enable Human Supervision** | Assign authorized reviewers to catch potentially harmful instructions |
| **Restrictive security groups** | Limit who can create and use automation agents |
| **Use Azure Key Vault** | For stored credentials in production, prefer Key Vault over internal storage |

> **Pro Tip (AVD/W365 perspective):** Use a **Windows 365 Cloud PC** or **Azure Virtual Desktop** session host as your agent machine. This gives you a fully managed, isolated environment that you can lock down with Intune policies, Conditional Access, and WDAC — without risking your corporate endpoints.

---

## Licensing & Billing

Computer Use is billed using the **Agent action** feature:

| Item | Cost |
|---|---|
| **Per step** | **5 Copilot Credits** |
| **Example: 4-step task** | 20 Copilot Credits total |

A "step" may involve one or more low-level actions (clicking, typing, navigating). Each reasoning + action cycle counts as one step.

**Example breakdown:**

| Step | Action |
|---|---|
| 1 | Launch browser and navigate to the timesheet portal |
| 2 | Select "Create new timesheet" |
| 3 | Fill in Start Time, End Time, and Project Code fields |
| 4 | Select the Submit button |
| **Total** | **4 steps = 20 Copilot Credits** |

> **Docs Reference:** [Microsoft Copilot Studio billing rate and management](https://learn.microsoft.com/en-us/microsoft-copilot-studio/requirements-messages-management)

---

## Known Limitations

Be aware of these limitations during preview:

| Limitation | Details |
|---|---|
| **US region only** | Computer Use is only available in US-region Power Platform environments |
| **Web > Desktop success rate** | ~80% success on web-based tasks, ~35% on desktop apps |
| **Inconsistent results** | Same task may yield different outcomes due to visual/timing changes |
| **UI control challenges** | Dropdowns, date pickers, and custom widgets can be problematic |
| **Loop states** | Agent may get stuck if the screen doesn't match expectations |
| **Complex tasks** | Struggles with intricate text manipulation and detailed graphical interfaces |
| **Hosted browser throttling** | Not for production use — may be throttled based on demand |
| **Password field support** | Works with most Windows apps but not Electron, Java, Unity, games, CLI, Citrix, or virtualized environments |

---

## Troubleshooting

| Issue | Solution |
|---|---|
| Computer Use not available | Verify your environment region is set to **United States** |
| Can't select Anthropic model | Enable external models in both **M365 admin center** and **Power Platform admin center** |
| Agent doesn't trigger Computer Use | Ensure **generative orchestration** is enabled (Settings > Generative AI > Orchestration > Yes) |
| Tool not finding correct buttons | Refine instructions — be more specific about element locations, use step-by-step formatting |
| Agent loops or gets stuck | Add explicit "stop" conditions and break complex tasks into smaller steps |
| Hosted browser slow or unavailable | Switch to Bring-Your-Own-Machine or Cloud PC pool for reliable performance |
| Credentials not working | Verify stored credentials match the exact login domain (e.g., `login.microsoft.com`, not `microsoft.com`) |
| Human supervision emails not arriving | Confirm reviewer is configured and the agent maker is the connection owner |

---

## End-to-End Checklist

Use this checklist to verify you haven't missed anything:

- [ ] Power Platform environment created in **US region** with **Dataverse**
- [ ] (Optional) Anthropic models enabled in M365 admin center
- [ ] (Optional) External models enabled in Power Platform admin center
- [ ] Copilot Studio opened with US environment selected
- [ ] Agent created with **generative orchestration** enabled
- [ ] Computer Use tool added with clear, step-by-step instructions
- [ ] AI model selected (OpenAI CUA or Anthropic Claude Sonnet 4.5)
- [ ] Machine configured (hosted browser, Cloud PC pool, or BYOM)
- [ ] Credentials configured (maker-provided, end user, or stored)
- [ ] Access control configured (allowed websites and desktop apps)
- [ ] Human supervision configured with reviewer email
- [ ] Agent tested and instructions refined
- [ ] Security best practices applied (dedicated machine, least privilege, web restrictions, WDAC)
- [ ] Agent published

---

## Resources

| Resource | Link |
|---|---|
| **Official Documentation** | [Automate web and desktop apps with computer use (preview)](https://learn.microsoft.com/en-us/microsoft-copilot-studio/computer-use) |
| **Configure Machine Options** | [Configure where computer use runs](https://learn.microsoft.com/en-us/microsoft-copilot-studio/configure-where-computer-use-runs) |
| **Human Supervision** | [Human supervision of computer use](https://learn.microsoft.com/en-us/microsoft-copilot-studio/human-supervision-computer-use) |
| **Generative Orchestration** | [Orchestrate agent behavior with generative AI](https://learn.microsoft.com/en-us/microsoft-copilot-studio/advanced-generative-actions) |
| **External Models Admin** | [Allow external language models](https://learn.microsoft.com/en-us/power-platform/admin/allow-llm-generative-responses) |
| **FAQ** | [FAQ for the computer use tool](https://learn.microsoft.com/en-us/microsoft-copilot-studio/faqs-computer-use) |
| **Power Automate Machine Setup** | [Manage machines](https://learn.microsoft.com/en-us/power-automate/desktop-flows/manage-machines) |
| **Copilot Studio Overview** | [What is Microsoft Copilot Studio?](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-what-is-copilot-studio) |
| **Feedback** | [computeruse-feedback@microsoft.com](mailto:computeruse-feedback@microsoft.com) |

---

*Posted on February 27, 2026 | Tags: Copilot Studio, Computer Use Agents, CUA, Power Platform, AI, Automation, RPA, Windows 365, AVD*
