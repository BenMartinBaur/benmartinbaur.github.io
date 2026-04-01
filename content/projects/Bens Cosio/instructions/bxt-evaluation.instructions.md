---
description: "Use when: evaluating AI use cases, scoring business viability, comparing use cases for prioritization, running Business Envisioning, deciding whether to Shelve/Research/Incubate/Accelerate a use case, post-workshop synthesis, BXT scoring, technology feasibility assessment, experience desirability analysis."
---

# BXT Use Case Evaluation

Evaluate and compare AI use cases using Microsoft's Business-Experience-Technology (BXT) framework to produce prioritization-ready outputs.

Sources:
- Microsoft BXT Framework — https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/business-envisioning
- Microsoft AI Decision Framework — https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html
- Microsoft Capability Envisioning — https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/capability-envisioning

## Core Principle

Inherited from ORDER: **"No Guessing."** Every score must be justified. Every assumption must be flagged with ⚠️.

**Important**: This is NOT a chatbot mode. When activated, switch into **evaluation mode** — structured, sequential, output-driven.

## Evaluation Pipeline

Execute steps sequentially. Do not skip.

### Step 1 — Normalize the Use Case

For each use case, confirm clarity before scoring:

- **Problem Statement**: What specific problem does this solve?
- **Target Users**: Who will use this — end users and internal stakeholders?
- **Expected Outcomes**: What does success look like?

If these cannot be clearly articulated, help refine them first. Do NOT score a vague use case.

### Step 2 — Intake Filter

Three gates from the AI Decision Framework:

1. **Business Outcome**: Can you state the precise ROI or problem solved? If unclear → pause and rewrite the problem statement.
2. **User Experience**: What interaction delivers that outcome? Does it need a chatbot, or just a smarter search bar?
3. **Existing Tools**: Does a tool already exist? Check existing SaaS/M365 capabilities first.

If any gate fails → ⛔ **Not ready for BXT scoring**. Recommend what needs to happen first.

### Step 3 — Strategic Fit Score (1–5)

Assess alignment with organizational strategy:

- **Business Objective**: What strategic objective does this use case serve?
- **Key Results**: What measurable outcomes indicate progress?
- **Primary Stakeholders**: Who is the executive sponsor? Who is accountable for OKRs?

### Step 4 — Business Viability (B)

Score each factor 1–5 with a short rationale:

**Executive Strategy Alignment**: Does the use case align with the organization's overall mission? Are key stakeholders identified and ready to engage? Is there executive sponsorship?

**Business Value**: Is there quantifiable value — cost savings, revenue, or productivity gains? What is the monetization approach (Core / Extend / Add-on)? What is TCO vs. benefit?

**Change Management Timeframe**: What is the realistic timeline to testing → pilot → revenue? Is this a quick win or long-term investment? Does complexity match available timeline?

### Step 5 — Experience Desirability (X)

Score each factor 1–5 with a short rationale:

**Key Personas**: Who are the end users? Are both technical and non-technical users considered? Are internal resources committed to building and maintaining?

**Value Proposition**: Is there a compelling reason to use this over the current alternative? Does it solve a painful and frequent problem? Does it fit naturally into existing workflows?

**Change Resistance**: What is users' willingness to adopt? What training is needed? What strategies mitigate resistance? How will you measure adoption?

### Step 6 — Technology Feasibility (T)

Score each factor 1–5 with a short rationale:

**Implementation & Operations Risks**: What technical issues, resource constraints, or data security concerns exist? Are mitigation strategies identified? Is contingency planning in place?

**Sufficient Safeguards**: Are security and compliance measures adequate? Data protection, access controls, Responsible AI standards? All regulatory requirements addressed?

**AI / LLM Fit**: Does the use case genuinely benefit from AI/LLM capabilities? Could traditional automation, rules engines, or basic search solve this without generative AI? Would the nondeterminism of LLMs create unacceptable risk?

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
- ✅ **Verified** — backed by data, stakeholder confirmation, or evidence
- ⚠️ **Assumed** — based on belief, incomplete information, or inference

For each assumption, recommend a specific verification action.

## Output Structure

Always produce this structure:

```
## Evaluation Details
Evaluator, Date, Client/Context, Workshop/Source, Number of Use Cases

## Use Case Summary
Table: # | Use Case Name | Problem Statement | Target Users | Expected Outcomes

## Intake Filter
Table: # | Use Case | Business Outcome Clear? | UX Defined? | Existing Tool? | Gate Result

## Strategic Fit Assessment
Table: # | Use Case | Business Objective | Key Results | Stakeholders | Score /5

## BXT Scorecard — [Use Case Name]

### Business Viability (B)
Table: Factor | Score /5 | Rationale | Confidence (Verified/Assumed)
Average Business Score

### Experience Desirability (X)
Table: Factor | Score /5 | Rationale | Confidence (Verified/Assumed)
Average Experience Score

### Technology Feasibility (T)
Table: Factor | Score /5 | Rationale | Confidence (Verified/Assumed)
Average Technology Score

## Composite Scores & Prioritization
Table: # | Use Case | Strategic Fit | B | X | T | Strategic Business Impact | Executional Fit | Quadrant

## Quadrant Map (ASCII visualization)

## Assumptions & Yellow Lights
Table: # | Use Case | Factor | Assumption | Verification Action | Priority

## 🟡 Yellow Lights (Responsible AI & Risk)
Table: # | Use Case | Concern | Category | Recommended Action

## Recommendation
Table: # | Use Case | Quadrant | Recommendation | Immediate Next Step

## Next Steps
Table: # | Action | Owner | Due Date
```

## Behavior Rules

1. **Non-chatty**: Produce structured outputs, not free-form discussion
2. **Sequential**: Always proceed Step 1 → Step 8, do not skip steps
3. **Comparative**: When multiple use cases, always produce side-by-side comparison and relative ranking
4. **Flag assumptions**: Use ⚠️ consistently — never let unverified scores pass silently
5. **Responsible AI**: If a use case raises concerns about bias, fairness, transparency, privacy, or safety — surface as 🟡 Yellow Light immediately
6. **Connect to ORDER**: If ORDER data exists for this client, reference it — Opportunity Impact feeds Business Viability, Stakeholders feed Key Personas

## Handover to ORDER

Unverified BXT assumptions should become ORDER meeting agenda items. After evaluation:
- Flag which assumptions need client verification
- Suggest specific questions to ask in the next meeting
- Note which ORDER elements the answers would fill
