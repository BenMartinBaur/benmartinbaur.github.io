---
name: customer-journey
description: 'Plan and orchestrate customer engagement journeys through the Innovation Hub 4-stage pipeline. Use when: planning a new customer engagement, sequencing workshops, deciding where to start with a customer, mapping engagement stages to skills, or tracking journey progress. Produces structured journey plans with timeline, stakeholder requirements, and skill activation maps.'
argument-hint: 'Describe the customer and what you know about their situation'
---

# Customer Journey

Orchestrate customer engagement stages through the Innovation Hub pipeline — from problem exploration to technical proof.

## Source

Microsoft Innovation Hub Engagement Model — 4-stage pipeline:

1. **Business Envisioning** → Develop and prioritize use cases
2. **Solution Envisioning** → Agree technical direction
3. **Architecture Design** → Architect the solution
4. **Rapid Prototype** → Prove capabilities

## When to Use

- Planning a new customer engagement → produces a journey plan
- Deciding where to start with a customer → assesses entry point
- Sequencing workshops across stages → generates an ordered plan
- Tracking engagement progress → updates journey status after each workshop
- Mapping engagement outputs to next steps → skill activation recommendations

## Core Principle

**Meet customers where they are.** Not every customer starts at Stage 1. Assess maturity, prior history, and readiness to determine the right entry point. Then sequence with precision and deliver with rigour.

## Procedure

### INTAKE — Collect Customer Context

Gather the following before planning:

| Field | Required | Source |
|-------|----------|--------|
| Customer name | Yes | Ben |
| Industry / Vertical | Yes | Ben or CRM |
| AI / Digital maturity | Yes | Ben's assessment |
| Known problems or opportunities | Yes | Ben, prior meetings, CRM |
| Key stakeholders identified | Recommended | Ben, ORDER data |
| Timeline or deadline pressures | Recommended | Ben |
| Prior Innovation Hub history | Optional | CRM, past engagement records |
| Existing ORDER or BXT outputs | Optional | Prior skill outputs |

### ASSESS STARTING POINT — Where Is the Customer?

Evaluate entry criteria to determine the right starting stage:

| Stage | Entry Criteria | Customer Signals |
|-------|---------------|-----------------|
| **Business Envisioning** | Agreed focus or theme, but no defined use cases | "We know we want to do something with AI but don't know where to start" |
| **Solution Envisioning** | Agreed problem universe and constraints, needs technical direction | "We have use cases but need to understand what's possible" |
| **Architecture Design** | Tightly defined problem or opportunity, needs implementation plan | "We know what we want to build, need to design it" |
| **Rapid Prototype** | High-level architecture exists, defined risks to mitigate | "We need to prove this works before committing" |

If prior ORDER or BXT data exists, use it to fast-track the assessment.

### SEQUENCE WORKSHOPS — Generate the Journey Plan

For each stage the customer needs, define:

| Field | Description |
|-------|-------------|
| **Stage** | Which engagement stage |
| **Duration** | Typical engagement length (half-day, full-day, multi-day) |
| **Entry Criteria** | What must be true before this stage starts |
| **Key Output** | What this stage produces |
| **Exit Criteria** | What must be true to move to the next stage |
| **Stakeholders Required** | Who must attend from the customer side |
| **Hub Resources** | Which Innovation Hub roles are needed |

### MAP TO SKILLS — Skill Activation per Stage

Each journey stage maps to specific Cosio skills:

| Journey Stage | Primary Skill | Supporting Skill | What Happens |
|---------------|--------------|-----------------|-------------|
| **Business Envisioning** | BXT Evaluation | — | Develop use cases, score with BXT, prioritize backlog |
| **Solution Envisioning** | ORDER Meeting | BXT Evaluation | Khalsa methodology workshops, detailed problem definition, evidence of impact |
| **Architecture Design** | ORDER Meeting | BXT Evaluation | Technical requirements synthesis, architecture decisions, risk identification |
| **Rapid Prototype** | ORDER Meeting | — | Prototype scoping, capability proof, demo preparation |

After each stage, the agent should offer to activate the mapped skill(s).

### TIMELINE VIEW — Visual Journey Plan

Produce a timeline showing:
- Stages in sequence with dates (estimated or confirmed)
- Dependencies between stages
- Parallel workstreams if applicable
- Key milestones and decision points

### HANDOVER TRACKING — Update Journey Status

After each workshop or engagement:

1. Update the journey status for that stage (Not Started → In Progress → Complete)
2. Capture key outputs and decisions
3. Assess readiness for the next stage against entry criteria
4. Flag any gaps that need to be filled before proceeding
5. Recommend next actions and skill activations

## Output Structure

Produce this structure for every journey plan:

```
## Customer Overview
Customer name, industry, maturity assessment, known context

## Journey Assessment
Starting point rationale, stages needed, estimated timeline

## Journey Stages

### Stage N: [Stage Name]
- Duration:
- Entry Criteria:
- Key Output:
- Exit Criteria:
- Stakeholders Required:
- Skill Activation: [ORDER / BXT / Both]
- Status: ☐ Not Started ☐ In Progress ☐ Complete

## Timeline
Visual or tabular timeline with milestones

## Stakeholder Requirements
Table: Stage | Customer Stakeholders | Hub Resources | Notes

## Skill Activation Map
Table: Stage | Skill | Trigger | Expected Output

## Gaps & Risks
Table: Gap/Risk | Impact | Mitigation | Priority

## Current Status & Next Steps
Table: Action | Owner | Due Date
```

## Behavior Rules

1. **Assess before planning**: Always determine the starting point before generating a plan
2. **Stage-gated**: Respect entry criteria — do not skip stages unless justified
3. **Skill-aware**: Always map stages to skill activations
4. **Structured output**: Journey plans are tables and timelines, not prose
5. **Track progress**: After each engagement, update the journey and assess next stage readiness
6. **No Guessing**: Flag assumptions about customer maturity or readiness with ⚠️

## Handover Points

| From Journey Stage | Feeds Into | How |
|-------------------|-----------|-----|
| Business Envisioning outputs | BXT Evaluation | Use cases from workshop → BXT scoring |
| Solution Envisioning outputs | ORDER Meeting (prep) | Technical direction → structured meeting prep |
| Architecture Design outputs | ORDER Meeting (summary) | Architecture decisions → structured follow-up |
| Rapid Prototype outcomes | Customer Journey (status update) | Proof results → journey completion or iteration |
| Any stage gap | ORDER Meeting | Unresolved gaps become meeting agenda items |
| BXT "Accelerate" results | Architecture Design stage | High-priority use cases advance to architecture |

## Source Frameworks

- **Innovation Hub Engagement Model**: 4-stage pipeline (Business Envisioning → Solution Envisioning → Architecture Design → Rapid Prototype)
- **Microsoft Common Envisioning Framework**: Business and Capability envisioning methodology
- **LUMA Framework**: Human-centered design thinking approach (Business Envisioning stage)
- **Khalsa Methodology**: ORDER consultative framework (Solution Envisioning stage)
