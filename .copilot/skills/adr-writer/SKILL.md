---
name: "adr-writer"
description: "Create Architecture Decision Records (ADRs) from customer workshop material (meeting transcripts, notes, RFPs, requirement docs, and architecture artifacts). Use this skill whenever users ask for ADRs, architecture decisions, decision logs, option analysis, or decision-ready architecture documentation, even if they do not explicitly say 'ADR'."
domain: "architecture, decision-records"
confidence: "high"
source: "authored (2026-06-23)"
---

## Purpose

Turn workshop evidence into decision-quality ADRs that customers can approve and implementation teams can execute without ambiguity.

This skill follows practical ADR conventions from Michael Nygard and MADR-style structure, with explicit traceability to source evidence and measurable validation criteria.

## When to use this skill

Use this skill when the user provides or references:
- Workshop transcripts
- Discovery session notes
- Architecture alternatives
- Non-functional requirements
- Constraints from compliance, security, operations, or budget
- Requests such as "document the decision", "write the architecture decision", or "prepare a decision record"

## Required inputs

Gather these inputs before drafting:
1. Workshop transcript(s)
2. Supporting documents (requirements, existing architecture, standards, constraints)
3. Decision scope (single decision or full decision set)
4. Intended audience and approvers
5. Timeline context (target release or milestone)

If data is missing, proceed with assumptions clearly marked as `NEEDS_CONFIRMATION`.

## Workflow

### 1. Extract decision evidence

From transcript and documents, extract:
- Problem statement
- Decision drivers (business, technical, regulatory, delivery)
- Constraints
- Considered alternatives
- Explicit stakeholder preferences
- Risks and open questions

Do not invent facts. Every major claim must map to an input source.

### 2. Normalize and cluster decisions

Split material into one ADR per architectural decision. A decision is ADR-worthy when it materially affects:
- System structure or integration
- Security/compliance posture
- Scalability/reliability/cost profile
- Team execution path or delivery risk

If many decisions exist, create an ADR index and sequence them by dependency.

### 3. Write ADRs with strict structure

Use the template in `references/adr-template.md` exactly. Keep each ADR concise, concrete, and approval-ready.

### 4. Add traceability and quality gates

For each ADR:
- Link key statements to source evidence excerpts
- Include measurable success/validation criteria
- List unresolved items under `NEEDS_CONFIRMATION`
- Ensure consequence analysis includes both positive and negative outcomes

### 5. Final consistency pass

Check that:
- Status and recommendation are unambiguous
- Rationale explains why selected option beats alternatives
- Risks have concrete mitigations and owners where possible
- Dependencies between ADRs are explicit

## Output format

Produce one or more ADRs in this form:
- If single decision: one ADR document
- If multiple decisions: an ADR index followed by per-decision ADRs

Use stable IDs:
- `ADR-001`, `ADR-002`, ...

Use status values:
- `Proposed`, `Accepted`, `Superseded`, `Rejected`, `Deprecated`

## Evidence and citation rules

For each ADR, include:
- **Source evidence table** with artifact name and excerpt/summary
- Clear distinction between:
  - confirmed facts
  - assumptions
  - open questions

If transcript statements conflict, document conflict explicitly and add a resolution item under `NEEDS_CONFIRMATION`.

## Style rules

- Prefer specific, testable statements over abstract wording
- Use direct, neutral language
- Keep option analysis balanced; do not hide trade-offs
- Avoid implementation detail overload unless it is decision-relevant
- Do not use hype language

## Anti-patterns

- Writing one giant ADR for unrelated decisions
- Omitting rejected alternatives
- Declaring certainty when evidence is incomplete
- Missing negative consequences
- Missing validation criteria
- Mixing requirement specification and decision rationale without clear boundaries

## Example trigger prompts

1. "Use this workshop transcript and produce ADRs for the data platform decisions."
2. "Create an architecture decision record for build vs buy based on these meeting notes."
3. "Turn these customer workshop docs into decision-ready architecture records."
