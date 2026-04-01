---
name: bxt-evaluation
description: 'Evaluate and prioritize AI use cases using Microsoft''s Business-Experience-Technology (BXT) framework. Use when: evaluating use cases after a workshop, comparing use cases for prioritization, scoring business viability or technical feasibility, deciding whether to Shelve/Research/Incubate/Accelerate a use case, or running a Business Envisioning session. Produces structured BXT scorecards with quadrant placement.'
argument-hint: 'Describe the use case(s) to evaluate or paste workshop notes'
---

# BXT Use Case Evaluation

Evaluate and compare AI use cases using the Business-Experience-Technology framework to produce prioritization-ready outputs.

## Source

- Microsoft BXT Framework — [Business Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/business-envisioning)
- Microsoft AI Decision Framework — [Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html)
- Microsoft Capability Envisioning — [Capability Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/capability-envisioning)

## When to Use

- After a Business Envisioning workshop → score and rank the generated use cases
- When comparing multiple use cases → produce side-by-side assessment
- Before committing resources → validate viability, desirability, and feasibility
- When someone asks "Is this use case worth building?" → structured answer

## Core Principle

Inherited from ORDER: **"No Guessing."** Every score must be justified. Every assumption must be flagged with ⚠️.

**Important**: This skill is NOT a chatbot. When activated, switch into **evaluation mode** — structured, sequential, output-driven.

## Procedure

### Step 1 — Normalize the Use Case

For each use case, confirm clarity before scoring:

- **Problem Statement**: What specific problem does this solve?
- **Target Users**: Who will use this? Both end users and internal stakeholders.
- **Expected Outcomes**: What does success look like?

If these cannot be articulated clearly, help refine them first. Do NOT score a vague use case.

### Step 2 — Intake Filter

Run the three-gate check from the [AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html):

1. **Business Outcome**: Can you state the precise ROI or problem solved? If not, pause.
2. **User Experience**: What interaction delivers that outcome? Does it need a chatbot, or just a smarter search bar?
3. **Existing Tools**: Does a tool already exist? Check existing SaaS/M365 capabilities first.

If any gate fails → ⛔ **Not ready for BXT scoring**. Recommend what needs to happen first.

### Step 3 — Strategic Fit (1–5)

Assess alignment with organizational strategy:

| Factor | Question |
|--------|----------|
| Business Objective | What strategic objective does this use case serve? |
| Key Results | What measurable outcomes indicate progress? |
| Primary Stakeholders | Who is the executive sponsor? Who is accountable for OKRs? |

### Step 4 — Business Viability (B)

Score each factor 1–5 with rationale:

| Factor | Key Questions |
|--------|--------------|
| **Executive Strategy Alignment** | Does it align with overall mission? Are key stakeholders identified and ready? |
| **Business Value** | Quantifiable ROI? Monetization approach (Core / Extend / Add-on)? TCO vs. benefit? |
| **Change Management Timeframe** | Realistic timeline to testing → pilot → revenue? Quick win or long-term? |

### Step 5 — Experience Desirability (X)

Score each factor 1–5 with rationale:

| Factor | Key Questions |
|--------|--------------|
| **Key Personas** | Who are end users? Technical and non-technical considered? Internal resources committed? |
| **Value Proposition** | Compelling reason over current alternative? Solves painful, frequent problem? Fits workflow? |
| **Change Resistance** | Users' willingness to adopt? Training needed? Mitigation strategies? Adoption measurement? |

### Step 6 — Technology Feasibility (T)

Score each factor 1–5 with rationale:

| Factor | Key Questions |
|--------|--------------|
| **Implementation & Ops Risks** | Technical issues, resource constraints, data security? Mitigation strategies? |
| **Sufficient Safeguards** | Security, compliance, data protection, Responsible AI standards met? |
| **AI / LLM Fit** | Genuinely benefits from AI/LLM? Could traditional automation suffice? Nondeterminism acceptable? |

### Step 7 — Synthesis & Prioritization

Calculate composite scores:

- **Strategic Business Impact** = (Strategic Fit + Business Score) / 2
- **Executional Fit** = (Experience Score + Technology Score) / 2

Map to quadrant:

| Quadrant | Impact | Fit | Action |
|----------|--------|-----|--------|
| **Shelve** | Low | Low | Not viable — shelve until circumstances change |
| **Research** | High | Low | Promising but unfeasible — investigate blockers |
| **Incubate** | Low | High | Feasible but limited impact — prototype and test |
| **Accelerate to MVP** | High | High | Go — invest and build |

### Step 8 — Assumptions Audit

For every score, mark:
- ✅ **Verified** — backed by data or stakeholder confirmation
- ⚠️ **Assumed** — based on belief or incomplete information

For each assumption, recommend a specific verification action.

Output using [evaluation template](./templates/evaluation-template.md).

## Behavior Rules

1. **Non-chatty**: Produce structured outputs, not free-form discussion
2. **Sequential**: Always proceed Step 1 → Step 8, do not skip steps
3. **Comparative**: When multiple use cases, always produce side-by-side comparison
4. **Flag assumptions**: Use ⚠️ consistently — never let unverified scores pass
5. **Responsible AI**: Surface bias, fairness, privacy, safety concerns as 🟡 Yellow Lights
6. **Connect to ORDER**: If ORDER data exists, reference it — Opportunity → Impact feeds Business Viability

## Handover Points

| From BXT Element | Feeds Into | How |
|------------------|-----------|-----|
| Accelerate to MVP | Capability Envisioning | Prioritized use case moves to approach selection |
| Technology Feasibility | AI Decision Framework Phase 2 | Feeds the Nine Critical Questions |
| Key Personas | ORDER → Stakeholders | Identified personas feed ORDER Decision mapping |
| Assumptions flagged | ORDER → Verification questions | Unverified assumptions become meeting agenda items |

## Knowledge Sources

See [knowledge sources](./references/knowledge-sources.md) for recommended uploads and connectors.
