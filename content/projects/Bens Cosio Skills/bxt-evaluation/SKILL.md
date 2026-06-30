---
name: bxt-evaluation
description: 'Score and rank AI use cases using the Business-Experience-Technology framework. Use when prioritizing use case portfolios, deciding which ideas to build vs. shelve, or evaluating business viability and technical feasibility. Produces scorecards, quadrant placements, and prioritized rankings. Triggers on: "prioritize use cases", "which AI project should we build", "is this AI idea worth it", "use case evaluation", "business viability", "technical feasibility".'
license: MIT
metadata:
  author: bebaur
  version: "2.0"
---

# BXT Use Case Evaluation

Evaluate and compare AI use cases using Microsoft's Business-Experience-Technology (BXT) framework to produce prioritization-ready outputs.

## Sources

- [Business Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/business-envisioning)
- [AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html)
- [Capability Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/capability-envisioning)
- Microsoft Responsible AI Standard v2

## When to Use

- After a Business Envisioning workshop → score and rank the generated use cases
- When comparing multiple use cases → produce side-by-side assessment
- Before committing resources → validate viability, desirability, and feasibility
- When someone asks "Is this use case worth building?" → structured answer

## Core Principle

Inherited from ORDER: **"No Guessing."** Every score must be justified. Every assumption must be flagged with ⚠️.

**Important**: When activated, work in **evaluation mode** — structured, sequential, and output-driven. The BXT framework's value comes from disciplined scoring with justified rationale, not free-form discussion. Each score needs evidence or a flagged assumption.

## Evaluation Pipeline

Execute steps sequentially. Do not skip.

### Step 1 — Normalize the Use Case

For each use case, confirm clarity before scoring:

- **Problem Statement**: What specific problem does this solve?
- **Target Users**: Who will use this — end users and internal stakeholders?
- **Expected Outcomes**: What does success look like?

If these cannot be clearly articulated, help refine them first. Do NOT score a vague use case.

### Step 2 — Intake Filter

Run the three-gate check from the [AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html):

1. **Business Outcome**: Can you state the precise ROI or problem solved? If unclear → pause and rewrite the problem statement.
2. **User Experience**: What interaction delivers that outcome? Does it need a chatbot, or just a smarter search bar?
3. **Existing Tools**: Does a tool already exist? Check existing SaaS/M365 capabilities first.

If any gate fails → ⛔ **Not ready for BXT scoring**. Recommend what needs to happen first.

### Step 3 — Strategic Fit Score (1–5)

Assess alignment with organizational strategy:

| Factor | Question |
|--------|----------|
| Business Objective | What strategic objective does this use case serve? |
| Key Results | What measurable outcomes indicate progress? |
| Primary Stakeholders | Who is the executive sponsor? Who is accountable for OKRs? |

Assign a score from 1 (no alignment) to 5 (direct strategic pillar).

### Step 4 — Business Viability (B)

Score each factor 1–5 with a short rationale:

**Executive Strategy Alignment**: Does the use case align with the organization's overall mission? Are key stakeholders identified and ready to engage? Is there executive sponsorship?

**Business Value**: Is there quantifiable value — cost savings, revenue, or productivity gains? What is the monetization approach (Core / Extend / Add-on)? What is TCO vs. benefit?

**Change Management Timeframe**: What is the realistic timeline to testing → pilot → revenue? Is this a quick win or long-term investment? Does complexity match available timeline?

Output: Score per factor + average Business score.

### Step 5 — Experience Desirability (X)

Score each factor 1–5 with a short rationale:

**Key Personas**: Who are the end users? Are both technical and non-technical users considered? Are internal resources committed to building and maintaining?

**Value Proposition**: Is there a compelling reason to use this over the current alternative? Does it solve a painful and frequent problem? Does it fit naturally into existing workflows?

**Change Resistance**: What is users' willingness to adopt? What training is needed? What strategies mitigate resistance? How will you measure adoption?

Output: Score per factor + average Experience score.

### Step 6 — Technology Feasibility (T)

Score each factor 1–5 with a short rationale:

**Implementation & Operations Risks**: What technical issues, resource constraints, or data security concerns exist? Are mitigation strategies identified? Is contingency planning in place?

**Sufficient Safeguards**: Are security and compliance measures adequate? Data protection, access controls, Responsible AI standards? All regulatory requirements addressed?

**AI / LLM Fit**: Does the use case genuinely benefit from AI/LLM capabilities? Could traditional automation, rules engines, or basic search solve this without generative AI? Would the nondeterminism of LLMs create unacceptable risk?

Output: Score per factor + average Technology score.

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

Output using [evaluation template](./assets/evaluation-template.md).

## Output File

Save the evaluation as a `.md` file using this naming convention:

```
<YYYY-MM-DD>_<Client>BXT-Evaluation.md
```

Example: `2026-06-19_ContosoBXT-Evaluation.md`

Place the file in the current working directory unless the user specifies a different location. If the client name or date is unknown, ask before saving.

## Output Structure

Always produce this 7-part structure:

1. **Use Case Summary Table** — Problem, users, outcomes per use case
2. **BXT Scorecard** — All 9 sub-scores with rationale per factor
3. **Composite Scores** — Strategic Business Impact + Executional Fit
4. **Quadrant Placement** — Visual/tabular mapping
5. **Comparison Table** (if multiple use cases) — side-by-side ranking
6. **Assumptions & Yellow Lights** — What's verified vs. guessed, Responsible AI flags
7. **Recommendation & Next Steps** — Clear action per use case

## Behavior Rules

1. **Non-chatty**: Produce structured outputs, not free-form discussion
2. **Sequential**: Always proceed Step 1 → Step 8, do not skip steps
3. **Comparative**: When multiple use cases, always produce side-by-side comparison and relative ranking
4. **Flag assumptions**: Use ⚠️ consistently — never let unverified scores pass silently
5. **Responsible AI**: If a use case raises concerns about bias, fairness, transparency, privacy, or safety — surface as 🟡 Yellow Light immediately

## Guardrails

These guardrails exist because BXT scoring depends on completeness and rigor — skipping steps or accepting vague inputs produces misleading quadrant placements that waste resources:

- Stay in evaluation mode during scoring. Free-form conversation breaks the scoring discipline and leads to unjustified scores.
- Use cases that fail the Intake Filter should not be scored. Scoring a vague use case produces false confidence — help refine the problem statement first.
- Follow the pipeline sequentially (Step 1 → Step 8). Each step builds on the previous one — skipping ahead means scores lack the context from earlier steps.
- Produce structured BXT outputs (scorecards, tables, quadrant maps). The structure makes score justifications and assumptions visible at a glance.

If the user explicitly asks to deviate (e.g., "just give me a quick assessment"), honor their request while noting what steps were skipped and how that affects confidence.

## Handover Points

When working alongside ORDER or Customer Journey skills, see [handover points](references/handover-points.md) for how BXT outputs feed into those frameworks and vice versa.
