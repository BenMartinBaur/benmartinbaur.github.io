# Innovation Hub Agent — Knowledge Sources

Shared knowledge sources across all skills. Upload or connect these in Copilot Studio.

---

## Shared Across All Skills

| Source | Type | Used By | Purpose |
|--------|------|---------|---------|
| Company CRM data (Dynamics 365 / Salesforce) | Dataverse connector / Plugin | ORDER, BXT | Pull account context, opportunity data, stakeholder maps |
| Past meeting notes & transcripts | SharePoint / OneDrive connector | ORDER, BXT | Reference prior outcomes, commitments, unresolved gaps |
| Account & Opportunity plans | SharePoint document library | ORDER, BXT | Strategic context per client relationship |
| Hub output templates | Document upload | All skills | Ensure consistent, Hub-standard deliverables |

---

## ORDER Skill — Knowledge Sources

| Source | Type | Purpose |
|--------|------|---------|
| *Let's Get Real or Let's Not Play* (2nd Ed., Khalsa & Illig) | PDF / Document upload | Primary ORDER methodology — dialogues, Yellow Light patterns, "No Guessing" philosophy |
| FranklinCovey "Helping Clients Succeed" materials | PDF / Document upload | Official ORDER worksheets, facilitator guides, role-play scenarios |
| Internal pricing & solution catalog | Document / Website URL | Map capabilities to client needs in "Exact Solution" phase |
| Discovery question bank | Document upload | Pre-built questions organized by ORDER element |
| Yellow Light checklist | Document upload | Common warning signs and recommended responses |
| Win/Loss analysis reports | Document upload | Patterns on what worked or didn't in past deals |
| Client-facing case studies | Document upload | Proof points for the Exact Solution phase |
| Competitor comparison matrices | Document upload | Competitive intelligence for the Decision Process phase |

---

## BXT Skill — Knowledge Sources

| Source | Type | Purpose |
|--------|------|---------|
| Microsoft Business Envisioning page | Website URL | Official BXT framework, scoring methodology, Contoso examples |
| | `https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/business-envisioning` | |
| Microsoft AI Decision Framework | Website URL | Three-phase methodology, Intake Filter, Nine Critical Questions |
| | `https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html` | |
| Microsoft Capability Envisioning page | Website URL | Approach selection (Adopt/Extend, Build Custom, Build on Fabric) |
| | `https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/capability-envisioning` | |
| Microsoft Responsible AI Standard v2 | PDF upload | Responsible AI guardrails for Technology Feasibility scoring |
| | `https://msblogs.thesourcemediaassets.com/sites/5/2022/06/Microsoft-Responsible-AI-Standard-v2-General-Requirements-3.pdf` | |
| ISV Extensibility Story | Website URL | Creating GenAI experiences — patterns, tools, journey map |
| | `https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/isv-extensibility-story` | |
| Industry use case examples | Document upload | Pre-built BXT examples from Manufacturing, Healthcare, Financial Services, Retail, Sustainability |
| Workshop output templates (Miro, Klaxoon) | Document upload | Standardized formats for capturing workshop brainstorming output |
| Prior BXT evaluations | Document upload | Completed scorecards from past engagements — helps calibrate scoring |

---

## Setup Priority

### Phase 1 — Minimum Viable Knowledge (start here)

1. Upload *Let's Get Real or Let's Not Play* PDF → ORDER gets full methodology context
2. Add the three Microsoft URLs as website knowledge sources → BXT gets framework grounding
3. Connect SharePoint for meeting notes → both skills can reference history

### Phase 2 — Enhance Quality

4. Upload your CRM connector → pre-populate account/opportunity data
5. Add internal solution/pricing docs → ORDER Exact Solution produces realistic outputs
6. Upload prior BXT evaluations → calibrates BXT scoring consistency

### Phase 3 — Scale & Refine

7. Add Responsible AI PDF → strengthens Technology Feasibility assessment
8. Upload competitor matrices and win/loss reports → sharpens ORDER Decision Process
9. Upload successful output examples → train the agent on what "good" looks like for your Hub

---

## Connector Notes for Copilot Studio

| Connector | Setup | Notes |
|-----------|-------|-------|
| **SharePoint** | Site URL + document library | Scope to specific libraries to avoid noise |
| **Dataverse** | Table selection | Filter to relevant entities (Accounts, Opportunities, Contacts) |
| **Website URL** | Direct URL | Microsoft Learn pages work well as knowledge sources |
| **File upload** | PDF, Word, Excel, PowerPoint | Max file size depends on Copilot Studio tier |
