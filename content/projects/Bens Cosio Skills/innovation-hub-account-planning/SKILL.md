---
name: innovation-hub-account-planning
description: 'Build FY27 Innovation Hub annual account plans using the AI Readiness Framework. Use this whenever the user mentions account planning, target account qualification, AI readiness scoring, customer priorities, H1/H2 AI deals, TPID lookup, Work IQ, Dynamics CRM pipeline, or asks for a consolidated account view. Trigger even when the user asks indirectly (for example "can you summarize this account and next move?"). Produces table-first outputs, including a Loop-ready structure and a markdown account plan.'
license: MIT
metadata:
  author: bebaur
  version: "1.0"
---

# Innovation Hub Annual Account Planning (FY27)

Create one consolidated account view for Innovation Hub planning (FY27: 1 Jul 2026 to 30 Jun 2027), anchored in the AI Readiness Framework and tied to concrete deals and Hub contribution.

## When to Use

- Annual account planning for Innovation Hub
- Target account qualification decisions
- Requests combining customer priorities, pipeline, and platform-readiness analysis
- Inputs that include customer name, TPID, Excel attachments, meeting notes, or CRM context

## Core Objective

Always answer these two qualification questions in a single account view:

1. **Deal level**: Where is AI potential and where are the big H1/H2 deals this year, and what can the Hub concretely contribute?
2. **Platform level**: Beyond deals, how do we land the Agentic Platform, where do we stand now, and what is the next customer journey move?

Qualification rule:
- Account is a **Target Account** only if:
  - (A) there is at least one concrete deal, and
  - (B) Account Team and Hub have a shared understanding of Hub contribution.
- If either is missing, mark as **Not Yet Target Account** and list missing evidence.

## Required Inputs

- Customer name
- TPID
- Additional account context from attached Excel and/or meeting notes

If a required input is missing, ask for it before final scoring.

## Data Collection Workflow

Run this sequence and keep evidence explicit:

1. **Normalize input pack**
   - Extract account identifiers from user input and files.
   - Build an input evidence table first.

2. **Web search and company intelligence**
   - Search for the company name and industry.
   - Retrieve a 2–3 sentence summary of the company and its primary industry.
   - Attempt to locate and analyze the company's latest annual report.
   - Map company strategy to Microsoft FY27 strategy pillars (Frontier Transformation and Core).

3. **Work IQ lookup**
   - Retrieve customer priorities, strategic themes, and workload context.
   - Capture exact signals and source fields in table form.

4. **Dynamics CRM MCP lookup**
   - Retrieve open opportunities, stage, value, timing (H1/H2), owners, blockers.
   - Identify named big deals and whitespace/AI potential signals.

5. **Meeting notes / file evidence extraction**
   - Extract customer priorities, decision dynamics, risks, and agreed actions.
   - Do not overwrite CRM/Work IQ facts; reconcile conflicts explicitly.

6. **Synthesize into one account picture**
   - Combine priorities + pipeline + readiness + ownership into one structured view.

## AI Readiness Framework Scoring (Platform Lens)

Score each pillar with evidence:

| Pillar | Scoring Question |
|---|---|
| M365 Copilot as the UI | Is Copilot the entry point and which business functions are live/next in flow of work? |
| Grounded in Enterprise Knowledge | Is enterprise knowledge grounded through IQ + Fabric, and what are the data gaps? |
| Scaling across all employees | Is deployment limited to pilots or scaling org-wide (Copilot Studio + Azure Foundry)? |
| Secured and Governed | Is governance in place (for example Agent 365 controls) and are agents production-ready? |

Use a 0-3 scale per pillar:
- 0 = Not started
- 1 = Early/pilot
- 2 = Established in key areas
- 3 = Scaled and operationalized

Every score must include evidence and confidence:
- ✅ Verified
- ⚠️ Assumed (with required follow-up action)

## Required Output Format

Use **tables for all core sections**. Keep narrative minimal and tied to table evidence.

Produce both outputs:

1. **Loop Page Structure** (Loop-ready, table-first blocks)
2. **Markdown File** saved to disk

Use templates:
- [Loop page template](./assets/loop-page-template.md)
- [Markdown account plan template](./assets/account-plan-template.md)

## Output Sections (all required)

1. Account Summary (customer name, industry, 2–3 sentence overview from web search)
2. Company Strategy Alignment (FY27 Frontier Transformation and Core pillars)
3. Solution Area Use Cases (table aligned to AI Business Solutions | Cloud & AI | Security)
4. Account Snapshot (customer, TPID, owners, qualification status)
5. Input Evidence Table (source by source)
6. Customer Priorities (from Work IQ + notes)
7. Pipeline & Big Deals (Dynamics CRM MCP; include H1/H2)
8. AI Potential / Whitespace
9. Qualification Check (Question 1 and Question 2 + pass/fail)
10. AI Readiness 4-Pillar Scorecard
11. Hub Mandate and Contribution by deal
12. Customer Journey Next Move (with owner and date)
13. Risks, Gaps, and Data Requests

## Behavior Rules

1. **Web Search and Company Intelligence:**
   - Always perform web search for the company name and industry.
   - Provide a 2–3 sentence summary of the company, its market position, and primary industry.
   - Attempt to locate the company's latest annual report (SEC filings for US public companies, annual reports from company websites).
   - If annual report is unavailable, note the gap and continue with available signals.

2. **Strategy Alignment Scoring:**
   - For each FY27 strategy pillar (both Frontier Transformation and Core), identify company strategy signals from annual report, web search, and Work IQ.
   - Map each company signal to a Microsoft opportunity area.
   - Identify specific Hub contribution opportunities (e.g., proof of concept, executive workshop, solution validation).

3. **Solution Area Use Cases:**
   - Generate 3–5 use cases aligned to the customer's priorities and industry.
   - For each use case, indicate which solution areas it touches: AI Business Solutions, Cloud & AI, Security (use ✓ or -).
   - Grade readiness level based on customer's current state: Early, Established, or Scaling.

4. Table-first outputs; avoid long prose blocks.
5. Distinguish facts from assumptions.
6. Keep source traceability in each major table.
7. If Work IQ or Dynamics CRM data is unavailable, mark the gap clearly and continue with partial output.
8. Never mark "Target Account" without both qualification conditions met.

## File Naming

Save markdown output as:

`<YYYY-MM-DD>_<CustomerName>_InnovationHubAccountPlan.md`

Example:

`2026-07-12_Contoso_InnovationHubAccountPlan.md`

If the customer name or date is unclear, ask before saving.
