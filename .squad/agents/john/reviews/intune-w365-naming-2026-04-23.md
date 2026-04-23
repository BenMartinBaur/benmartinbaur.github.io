## John's Review: Intune & Windows 365 — Naming Conventions & Best Practices Cheatsheet

**Review Date:** 2026-04-23
**Post Date:** 2026-04-10
**Pillar:** 🏗️ Build

**Technical Accuracy:** Flags: 3
**Architecture Quality:** Production-ready (with fixes below)
**Security Coverage:** Gaps: RBAC for scope tags, no data exfiltration mitigation guidance
**Scalability Addressed:** Partially
**Edge Cases:** Missing: policy conflict resolution, Entra ID group limits, multi-geo provisioning race conditions

---

### Critical Flags (must fix before next revision)

**1. Frontline Shared device name example exceeds 15-character NetBIOS limit**

> Section 2.6, "Recommended Templates" table, Frontline Shared row:
> `FLR-%RAND:12%` → `FLR-A7K2M3B9X4F1`

The prefix `FLR-` is 4 characters. `%RAND:12%` generates 12 random characters. **Total: 16 characters.** NetBIOS names are capped at 15. This template will fail at provisioning time.

The post's own rules (same section) state the total must be ≤ 15 characters with prefix ≤ 7 and RAND ≥ 8. A valid example:

- `FLR-%RAND:11%` → 4 + 11 = **15 characters** ✅
- Or `FLRSHR-%RAND:8%` → 7 + 8 = **15 characters** ✅

**Fix required.** Any reader copying this template into a provisioning policy will get a validation error.

---

**2. Cross-post inconsistency: CA 200-range conflict with the Agents post**

> Section 2.4, Conditional Access numbering table:
> `200–299` → "Mobile / BYOD policies"

The companion post *Windows 365 for AI Agents* (2026-04-23) uses the 200 range for **agent-specific** Conditional Access policies (`CA-201-AgentRequireCompliance`, `CA-202-AgentBlockExternalNetwork`, etc.) and explicitly states:

> "If you're following the naming conventions from my Intune & Windows 365 Naming Best Practices post, you'll notice the 200 range is a natural fit for agent-specific Conditional Access policies."

This directly contradicts the naming post's assignment of 200–299 to Mobile/BYOD. A reader following both posts will have a namespace collision.

**Fix:** Either:
- Reassign the agents post to a 400-range and add `400–499 | Agent / automated workload policies` to the naming post, or
- Change the naming post's 200-range to "Agent / automated workloads" and shift Mobile/BYOD to 400.

The agents post should be updated to match whichever convention is chosen.

---

**3. Quick reference table pattern inconsistent with deep-dive section**

> TL;DR table, Cloud PC Device Name row:
> Pattern: `CPC-<Prefix>-%RAND:5%` → Example: `CPC-DEV-%RAND:5%`

Section 2.6 shows `CPC-%RAND:5%` and `DEV-%RAND:5%` as **separate** templates — `CPC-` and `DEV-` are each the full prefix, not nested. The quick reference table implies a two-level prefix (`CPC-` + `<Prefix>-`) which is a different pattern entirely.

While `CPC-DEV-A7K2M` (13 chars) technically fits NetBIOS limits, the structural inconsistency between the summary table and the deep-dive will confuse readers building their own templates.

**Fix:** Align the TL;DR row with the deep-dive. Suggested pattern: `<Prefix>-%RAND:5%` with example `CPC-%RAND:5%` → `CPC-A7K2M`.

---

### Recommendations (should improve)

**4. "Reserve" is not a standard Windows 365 license type**

> Section 2.5, LicenseType values:
> `Reserve`

Windows 365 licensing tiers are **Enterprise**, **Frontline** (Dedicated/Shared), and **Business**. "Reserve" likely refers to Azure Reserved Instance pricing for Windows 365, which is a billing optimization — not a distinct license type that affects provisioning policy behavior. Including it as a provisioning policy prefix alongside actual license types conflates billing with architecture.

→ **Remove `Reserve`** from the LicenseType values or clarify it as a cost annotation suffix (e.g., `PP-Ent-RI-WEU-Developers` where `RI` denotes reserved instance pricing). Also consider adding `Biz` for Windows 365 Business if the guide is intended to cover that tier (noting Business has limited Intune management compared to Enterprise).

---

**5. Dynamic group rule needs service plan ID guidance**

> Section 2.1:
> `(user.assignedPlans -any (assignedPlan.servicePlanId -eq "your-w365-plan-id" -and assignedPlan.capabilityStatus -eq "Enabled"))`

The placeholder `"your-w365-plan-id"` without guidance on where to find the actual GUID will send readers on a documentation hunt. At scale (10,000+ users), dynamic group evaluation against `assignedPlans` is also one of the more expensive membership rules — it can take 24+ hours for initial population.

→ Add a note: *"Find your Windows 365 service plan IDs via `Get-MgSubscribedSku | Select-Object -ExpandProperty ServicePlans | Where-Object { $_.ServicePlanName -like '*W365*' }`. Initial dynamic group population can take up to 24 hours for large tenants."*

Reference: [Entra ID dynamic group processing times](https://learn.microsoft.com/en-us/entra/identity/users/groups-troubleshooting)

---

**6. BitLocker note is correct but incomplete**

> Section 2.3, Note:
> "BitLocker is not supported on Cloud PCs. Exclude this setting from compliance policies targeting Windows 365 devices."

This is accurate — Cloud PCs use Azure-managed server-side disk encryption (SSE with platform-managed keys by default), not BitLocker. But simply saying "not supported" without naming the alternative may alarm compliance-conscious readers.

→ Add: *"Cloud PCs are protected by Azure managed disk encryption (server-side encryption) at rest. BitLocker is not applicable because the virtual disk is encrypted at the storage layer. Exclude BitLocker compliance checks for Cloud PC-targeted policies."*

---

**7. Assignment filter model value should be more precise**

> Section 4, Deployment Matrix:
> `(device.model -contains "Cloud PC")`

The `-contains` operator works for substring matching, but the actual `device.model` values for Cloud PCs are typically `"Cloud PC Enterprise"` or `"Cloud PC Business"`. Using `-contains "Cloud PC"` will catch both, which is likely intentional. However, if a reader needs to distinguish between Enterprise and Business Cloud PCs in filters (common in mixed environments), this guidance doesn't address that.

→ Add a note documenting the known model values: `"Cloud PC Enterprise"`, `"Cloud PC Business"`. Mention that `-eq` can be used for precise targeting.

Reference: [Intune assignment filters device properties](https://learn.microsoft.com/en-us/mem/intune/fundamentals/filters-device-properties)

---

**8. Scope tags require RBAC role assignments — not mentioned**

> Section 3.5, Scope Tags:
> "Use scope tags when multiple teams manage different Cloud PC populations"

Scope tags alone don't enforce delegation. They must be paired with **Intune RBAC role assignments** that scope the admin to specific tags. Without the RBAC role configuration, scope tags are metadata with no enforcement. A reader who creates tags but doesn't configure roles will wonder why delegation isn't working.

→ Add: *"Scope tags must be paired with custom Intune RBAC roles. Assign tags to both the policies/devices and the admin role assignment to enforce delegation boundaries."*

---

**9. Missing completeness sections (per charter checklist)**

The charter requires Build posts to include or consciously omit:

| Section | Status in Post |
|---------|---------------|
| TL;DR / Quick Reference | ✅ Present |
| Architecture overview | ⚠️ Deployment matrix provided, but no visual architecture diagram |
| Security considerations | ⚠️ BitLocker note + CA guidance present, but no threat model or data exfiltration discussion |
| Scalability notes | ❌ Missing — no mention of Entra ID group limits (50,000 dynamic groups per tenant), Intune policy assignment limits, or Graph API throttling for the automation scripts |
| Edge cases | ❌ Missing — no discussion of policy conflicts, co-management scenarios, or multi-geo provisioning timing |
| Cost implications | ❌ Missing — no mention of Entra ID P1 cost for dynamic groups (beyond the inline note), Windows 365 license costs, or Graph API consumption |
| Troubleshooting guidance | ❌ Missing — no section on how to diagnose naming conflicts, provisioning failures due to name collisions, or compliance policy evaluation order |
| Source links | ✅ Present and relevant |

→ At minimum, add a **"Common Issues & Troubleshooting"** section covering: Cloud PC name collisions (what happens when `%RAND%` generates a duplicate NetBIOS name), compliance policy conflict resolution (which policy wins when multiple target the same device), and dynamic group evaluation delays.

---

**10. Companion repository not linked**

> Section 5:
> "The deployment scripts are available in the companion repository."

No URL is provided. The repository structure is shown but readers cannot access the code. If the repo isn't published yet, the post should say so explicitly. As written, it reads like a broken link.

→ Either add the GitHub repository URL or change to: *"The deployment scripts will be published in a companion repository — check back or follow on LinkedIn for the release."*

---

**11. Version-pinned names need an update strategy**

> `SBL-W365-24H1` — Security baseline named with version `24H1`

This is good practice for point-in-time clarity, but when Microsoft releases a 25H1 baseline, teams will need to create `SBL-W365-25H1` and migrate assignments. The post doesn't discuss the lifecycle of version-pinned policy names: how to handle transitions, whether to run old and new baselines in parallel, or whether to rename in-place.

→ Add a brief note: *"When a new baseline version is released, deploy the new baseline alongside the existing one (e.g., `SBL-W365-25H1`) and migrate group assignments. Do not rename existing baselines — Intune tracks policies by ID, not name, and renaming obscures audit history."*

---

**12. Frontline Shared naming rules — "Exactly 15 characters" may be overstated**

> Section 2.6:
> "Exactly 15 characters"

Microsoft's documentation for Frontline shared device name templates states the total length must be between 5 and 15 characters, with prefix ≤ 7 characters and RAND ≥ 8 characters. The minimum of prefix (1 char) + RAND (8) = 9 characters. It does not need to be *exactly* 15. The constraint is ≤ 15 total.

→ Verify against the latest docs. If the "exactly 15" constraint has changed, update to: *"5–15 characters, with prefix ≤ 7 characters and `%RAND:Y%` where Y ≥ 8."*

Reference: [Windows 365 device naming — Microsoft Learn](https://learn.microsoft.com/en-us/windows-365/enterprise/create-provisioning-policy#provide-a-device-name-template-enterprise-frontline)

---

### Cross-Post Consistency

| Reference | Status | Details |
|-----------|--------|---------|
| **CA 200-range** (naming post ↔ agents post) | ❌ **Inconsistent** | Naming post: 200 = Mobile/BYOD. Agents post: 200 = Agent policies. See Critical Flag #2. |
| **Security Baseline 24H1** (naming post ↔ agents post) | ✅ Consistent | Both reference "Windows 365 Security Baseline 24H1". |
| **Compliance / BitLocker** (naming post ↔ agents post) | ✅ Consistent | Agents post references "enforce encryption" in compliance — naming post correctly notes BitLocker exclusion for Cloud PCs. No conflict. |
| **Join type guidance** (naming post ↔ AVD post) | ✅ Consistent | Naming post recommends Entra Join + MHN. AVD post correctly distinguishes MHN (no VNet config needed) from ANC (explicit outbound required). |
| **Cross-reference from agents post** | ✅ Present | Agents post links to `/posts/2026-04-10-intune-w365-naming-best-practices/` — URL is correct. |
| **Cross-reference from naming post to AVD/agents posts** | ⚠️ Missing | The naming post doesn't reference either companion post. Adding cross-links would strengthen the content ecosystem, especially to the AVD post for ANC networking context. |

---

### Strengths

- **The naming convention system is well-structured and production-ready.** The prefix-based taxonomy (`GRP-`, `CFG-`, `CMP-`, `CA-`, `PP-`, etc.) is immediately recognizable, scriptable via Graph API filtering, and survives at enterprise scale. This is the kind of convention that, once adopted, pays dividends for years.

- **The deployment matrix (Section 4) is excellent.** Showing exactly how all the named objects connect — groups → policies → targets — gives readers a complete mental model. This is the "whiteboard view" that architects need.

- **The provisioning policy naming pattern is battle-tested.** Encoding license type, region, and use case in the PP name (`PP-Ent-WEU-Developers`) gives instant context in the admin center list view. For orgs managing multiple regions and license types, this eliminates guesswork.

- **The Join Type Selection table (Section 3.2) is clear and correctly prioritizes Entra Join with MHN.** This aligns with Microsoft's current guidance and avoids the hybrid join complexity that causes most provisioning issues.

- **The "never deploy without testing" warning and report-only default for automation scripts** reflect real field discipline. Too many blog posts ship "run this in production" scripts without guardrails.

- **Conditional Access numbering scheme with functional ranges** is a pattern I've seen succeed in Fortune 500 Intune deployments. It makes policy audits and reviews dramatically faster.

- **The writing voice matches the brand strategy.** Conversational, practical, experience-led ("If you've ever inherited an Intune tenant where policies are named `Test Policy 2 - Copy (final_v3)` — you know the pain"). This is the "smart colleague" tone the brand document calls for.

---

### Suggested Additions for Future Revision

| Topic | Why | Brief Outline |
|-------|-----|---------------|
| **Policy conflict resolution** | Readers deploying multiple compliance/config profiles to the same groups will hit conflicts. No current guidance. | Add a subsection: "When two policies target the same device with conflicting settings, Intune marks the setting as 'Conflict' and neither applies. Use assignment filters and group targeting to avoid overlap. Check Intune → Devices → Monitor → Assignment failures." |
| **Graph API throttling and batch limits** | The automation section promises Graph-based deployment but doesn't address throttling. At scale, bulk policy creation will hit 429 rate limits. | Add to Section 5: "Microsoft Graph enforces per-app and per-tenant throttling. Use `Retry-After` headers and exponential backoff. For bulk operations, batch requests in groups of 20 (Graph `$batch` endpoint limit)." |
| **Naming for Windows Autopatch integration** | Post mentions Autopatch in a tip (Section 2.9) but doesn't address how Autopatch-managed update rings interact with custom-named rings. | Add a callout: "If you enable Windows Autopatch, it creates its own ring groups and policies. Custom update rings targeting the same devices will conflict. Decide upfront: Autopatch-managed or custom-named rings, not both for the same device population." |
| **Multi-geo provisioning timing** | For enterprises in multiple regions, provisioning policies in different geographies can race against Entra ID replication. | Add to Section 3: "When creating groups and provisioning policies across regions, allow 5-15 minutes for Entra ID replication before assigning groups to provisioning policies in a different region." |
| **Naming conventions for Windows 365 for Agents** | The agents post (2026-04-23) introduces agent Cloud PCs but doesn't define naming extensions. This post should be the canonical naming reference. | Add a new Section 2.10: "Agent Cloud PCs" — pattern `PP-Agent-<Region>-<Workflow>`, group pattern `GRP-Agent-W365-<WorkflowName>`, CA range 400+. Cross-link to the agents post. |
| **Cost awareness for dynamic groups** | Dynamic group evaluation requires Entra ID P1/P2. At scale, many dynamic groups increase Entra processing time and licensing costs. | Add a note in Section 2.1: "Each dynamic group requires Entra ID P1 licensing for all evaluated users. For large tenants, prefer a mix of dynamic groups (for license-based membership) and assigned groups (for pilot/exception populations) to control cost and evaluation time." |

---

*Review complete. Three critical fixes required before the next revision. The post is architecturally sound and will serve as a strong canonical reference for Intune/W365 naming once the flagged issues are resolved.*
