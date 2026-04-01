# BXT Use Case Evaluation Skill — Contract

## Skill Identity

| Field | Value |
|-------|-------|
| **Skill Name** | BXT Use Case Evaluation |
| **Version** | 1.0 |
| **Source** | Microsoft Business-Experience-Technology (BXT) Framework — [Business Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/business-envisioning), [AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html) |
| **Type** | Structured evaluation skill (non-chatty, scoring + synthesis) |

## Purpose

Evaluate and compare AI/business use cases using the Business–Experience–Technology framework. Produce prioritization-ready outputs that determine whether to **Shelve**, **Research**, **Incubate**, or **Accelerate to MVP**.

## Trigger Conditions

| Trigger Phrases | Context |
|----------------|---------|
| "Evaluate these use cases" | User has one or more use cases to assess |
| "Which of these should we prioritize?" | User needs comparative ranking |
| "Turn this workshop output into a decision" | Post-workshop synthesis |
| "We ran a business envisioning session" | Workshop debrief |
| "Score this use case" | Single use case evaluation |
| "Is this use case viable?" | Viability check |

## Inputs

| Input | Required | Source |
|-------|----------|--------|
| One or more use case descriptions | Yes | User-provided, workshop notes, transcript |
| Problem statement per use case | Yes | User-provided |
| Target users / personas | Recommended | User-provided or inferred from ORDER data |
| Strategic context (business objectives, OKRs) | Recommended | User-provided or CRM |
| ORDER Opportunity data (if available) | Optional | Handover from ORDER Skill |
| Workshop notes, Miro/Klaxoon exports, transcripts | Optional | User-provided |

## Process (Execution Model)

This skill operates as a **structured evaluation pipeline** — not a chatty conversation.

### Step 1 — Strategic Fit Assessment

Before BXT scoring, establish the strategic baseline for each use case:

| Factor | Question |
|--------|----------|
| **Business Objective** | What business objective does this use case achieve? |
| **Key Results** | What measurable key results indicate progress? |
| **Primary Stakeholders** | Who is the executive sponsor? Who is accountable for OKRs? |
| **Strategic Fit Score** | Rate 1–5: How well does this align with organizational strategy? |

### Step 2 — Intake Filter (from AI Decision Framework)

Before scoring, validate the use case passes the intake gate:

1. **What business outcome am I trying to achieve?** — If unclear, pause and rewrite the problem statement.
2. **What user experience delivers that outcome?** — Prototype the interaction first.
3. **Does a tool already exist?** — Check existing tools before building new.

If any of these cannot be answered, flag the use case as **not ready for BXT scoring**.

### Step 3 — Business Viability (B)

Score each factor 1–5:

| Factor | Key Questions | Score |
|--------|--------------|-------|
| **Executive Strategy Alignment** | Does the use case align with overall mission? Are key stakeholders identified and ready to engage? Is there executive sponsorship? | /5 |
| **Business Value** | Is there quantifiable ROI (cost savings, revenue, productivity)? What is the monetization approach (Core / Extend / Add-on)? What is TCO vs. benefit? | /5 |
| **Change Management Timeframe** | When will the solution be ready for testing? What is the path to revenue? Does the complexity match available timeline? Is this a quick win or long-term investment? | /5 |
| | **Average Business Score** | /5 |

### Step 4 — Experience Desirability (X)

Score each factor 1–5:

| Factor | Key Questions | Score |
|--------|--------------|-------|
| **Key Personas** | Who are the end users and stakeholders? Are internal resources prepared and committed? Are both technical and non-technical users considered? | /5 |
| **Value Proposition** | Is there a motivating reason to use this over the current alternative? Does it solve a painful, frequent problem? Does it naturally fit existing workflows? | /5 |
| **Change Resistance** | What is the users' willingness to adopt? What training and guidance is needed? What strategies mitigate resistance? How do you measure adoption? | /5 |
| | **Average Experience Score** | /5 |

### Step 5 — Technology Feasibility (T)

Score each factor 1–5:

| Factor | Key Questions | Score |
|--------|--------------|-------|
| **Implementation & Operations Risks** | What technical issues, resource constraints, or data security concerns exist? Are mitigation strategies in place? Is contingency planning robust? | /5 |
| **Sufficient Safeguards** | Are security and compliance measures adequate? Are data protection and access controls in place? Does it meet Responsible AI standards? Are regulatory requirements addressed? | /5 |
| **AI / LLM Fit** | Does the use case align with AI/LLM capabilities? Can it benefit from automation and enhanced decision-making? Is it well-suited for generative AI specifically, or would traditional AI/ML suffice? | /5 |
| | **Average Technology Score** | /5 |

### Step 6 — Synthesis & Prioritization

Calculate composite scores and plot position:

| Metric | Formula |
|--------|---------|
| **Degree of Strategic Business Impact** | (Strategic Fit + Business Score) / 2 |
| **Degree of Executional Fit** | (Experience Score + Technology Score) / 2 |

Map to quadrant:

| Quadrant | Strategic Business Impact | Executional Fit | Action |
|----------|--------------------------|-----------------|--------|
| **Shelve** | Low | Low | Not viable — shelve until circumstances change |
| **Research** | High | Low | High potential but unfeasible — research problem space, user needs, market |
| **Incubate** | Low | High | Feasible but low impact — prototype and test in controlled environment |
| **Accelerate to MVP** | High | High | Ready for investment and development |

### Step 7 — Assumptions Audit

Apply the ORDER "No Guessing" principle: for every score, flag whether it is **verified** or **assumed**. Recommend specific actions to validate assumptions before committing resources.

## Output

The skill produces a structured evaluation report containing:

1. **Use Case Summary** — Normalized problem statement, target users, expected outcomes
2. **Strategic Fit Score** — With rationale
3. **BXT Scorecard** — All 9 sub-scores with rationale per factor
4. **Composite Scores** — Strategic Business Impact + Executional Fit
5. **Quadrant Placement** — Shelve / Research / Incubate / Accelerate
6. **Assumptions & Yellow Lights** — What's verified vs. guessed
7. **Recommendation** — Clear next steps per use case

## Output Template

`Skills/BXT/Evaluation-Template.md`

## Guardrails

| Rule | Behavior |
|------|----------|
| **Non-chatty** | This skill should feel like entering "evaluation mode" — structured, not conversational |
| **No Guessing** | Every score must be justified; assumptions explicitly flagged with ⚠️ |
| **Comparative** | When multiple use cases are provided, always produce a comparison table and relative ranking |
| **Intake gate first** | Always run the Intake Filter before scoring — catch non-starters early |
| **Responsible AI** | Flag any use case that raises Responsible AI concerns (bias, fairness, transparency, safety) |

## Handover Points

| From BXT Element | Feeds Into | How |
|------------------|-----------|-----|
| **Accelerate to MVP** | Capability Envisioning Skill | Prioritized use case moves to approach selection |
| **Technology Feasibility** | AI Decision Framework Phase 2 | Feasibility assessment informs the Nine Critical Questions |
| **Key Personas** | ORDER → Stakeholders | Identified personas feed back into ORDER Decision mapping |
| **Assumptions flagged** | ORDER → Verification questions | Unverified BXT assumptions become ORDER meeting agenda items |

## Dependencies

- **Knowledge sources**: BXT framework docs, AI Decision Framework, industry examples
- **Templates**: Evaluation-Template.md
- **Parent agent**: Innovation Hub Agent (orchestrator)
- **Optional upstream**: ORDER Skill outputs (Opportunity data, stakeholder maps)
