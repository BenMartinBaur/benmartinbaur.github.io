---
title: "Ben's Cosio — Innovation Hub Agent"
description: "A Copilot Studio agent system that orchestrates structured consulting frameworks across customer engagements for Microsoft Innovation Hub architects."
date: 2026-03-01
image: ""
tags:
  - AI
  - Framework
  - Consulting
categories:
  - Build
---

# Ben's Cosio — Innovation Hub Agent

**One agent. Multiple skills. Zero guessing.**

Ben's Cosio is the single front door for Microsoft Architects preparing, running, and following up on customer engagements. It replaces the need for multiple standalone agents with one intelligent assistant that applies the right framework when it matters.

---

## What Problem Does This Solve?

Innovation Hub architects juggle multiple frameworks across the engagement lifecycle — discovery questions, meeting preparation, use case evaluation, solution design, stakeholder mapping. Each framework lives in a different document, a different tool, a different person's head.

Ben's Cosio brings them together. When you say *"help me prepare for a meeting,"* it activates the ORDER Prep Skill. When you say *"evaluate these use cases,"* it activates BXT scoring. The architect doesn't need to know which framework to use — the agent detects context and invokes the right skill.

---

## Architecture

The system follows a **skill choreography** pattern: one orchestrating agent with multiple structured capabilities (skills), each with its own contract, templates, and references.

```
┌──────────────────────────────────────────────┐
│           Innovation Hub Agent               │
│          (Orchestration Layer)               │
├──────────┬───────────┬───────────┬───────────┤
│  ORDER   │    BXT    │ Capability│  Yellow   │
│ Meeting  │ Use Case  │Envisioning│  Light    │
│Discipline│Evaluation │ (future)  │Detection  │
│          │           │           │ (future)  │
└──────────┴───────────┴───────────┴───────────┘
         ▲                    ▲
         │   Skill Handovers  │
         └────────────────────┘
```

### Skill Choreography Flow

Skills are not isolated — they feed each other:

| From | To | What Transfers |
|------|----|----------------|
| ORDER → Opportunity & Impact | BXT | Business Viability score context |
| ORDER → Exact Solution | BXT | Technology Feasibility inputs |
| ORDER → Decision & Stakeholders | BXT | Experience / Key Personas mapping |
| BXT → Accelerate to MVP | Capability Envisioning | Approach selection (Adopt/Extend vs Build Custom vs Build on Fabric) |
| Any Skill output | Yellow Light Detection | Cross-cutting risk and assumption scan |

---

## Core Skills

### 🤝 ORDER Meeting Discipline

**Status:** ✅ Shipped

Based on *Let's Get Real or Let's Not Play* (2nd Ed.) by Mahan Khalsa & Randy Illig.

**What it does:** Structures pre-meeting preparation and post-meeting summaries using the ORDER framework — Opportunity, Resources, Decision Process, Exact Solution, Results.

**Triggers:**
- *"Help me prepare for a client meeting"*
- *"Summarize my meeting notes"*

**Outputs:**
- Structured prep documents with discovery questions per ORDER element
- Post-meeting summaries with commitments, gaps, and next steps
- Yellow Light flags for assumptions or missing information

**Files:**
- Skill contract: [`skills/order-meeting/SKILL.md`](skills/order-meeting/SKILL.md)
- Prep template: [`skills/order-meeting/templates/prep-template.md`](skills/order-meeting/templates/prep-template.md)
- Summary template: [`skills/order-meeting/templates/summary-template.md`](skills/order-meeting/templates/summary-template.md)
- Knowledge sources: [`skills/order-meeting/references/knowledge-sources.md`](skills/order-meeting/references/knowledge-sources.md)

---

### 📊 BXT Use Case Evaluation

**Status:** ✅ Shipped

Based on Microsoft's [Business Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/business-envisioning) framework and the [AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html).

**What it does:** Evaluates customer use cases against three dimensions — Business viability, Experience impact, and Technology feasibility — to produce a scored, prioritised backlog.

**Triggers:**
- *"Evaluate these use cases"*
- *"We ran a workshop — score the outputs"*

**Outputs:**
- BXT scorecard per use case (1-5 scale across B, X, T dimensions)
- Prioritised backlog with recommended sequencing
- Responsible AI flags per use case

**Files:**
- Skill contract: [`skills/bxt-evaluation/SKILL.md`](skills/bxt-evaluation/SKILL.md)
- Evaluation template: [`skills/bxt-evaluation/templates/evaluation-template.md`](skills/bxt-evaluation/templates/evaluation-template.md)
- Knowledge sources: [`skills/bxt-evaluation/references/knowledge-sources.md`](skills/bxt-evaluation/references/knowledge-sources.md)

---

### 🧭 Capability Envisioning *(Future)*

Based on Microsoft's [Capability Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/capability-envisioning) framework.

**What it will do:** After BXT scoring identifies high-priority use cases, this skill helps select the right development approach — Adopt/Extend existing tools, Build Custom solutions, or Build on Fabric/platform capabilities.

---

### 🚦 Yellow Light Detection *(Future)*

A cross-cutting risk scanner inspired by the "Yellow Light" concept from ORDER methodology.

**What it will do:** Scan any skill output for assumptions, missing information, stakeholder gaps, and engagement risks. Flags issues before they become blockers.

---

## Guardrails

These principles apply across all skills:

| Guardrail | What It Means |
|-----------|---------------|
| **No Guessing** | Flag assumptions explicitly. Push for verification rather than filling gaps with plausible fiction. |
| **Structured over chatty** | Skills produce templated outputs, not open-ended conversation. Every output follows Hub-standard formats. |
| **Intent over technique** | The framework serves the client. If genuine intent is missing, technique becomes manipulation. |
| **Hub-standard outputs** | All outputs can be directly used in client-facing materials without reformatting. |

---

## Knowledge Sources

The agent draws from both uploaded documents and connected data sources. Full details in [`Knowledge-Sources.md`](Knowledge-Sources.md).

**Phase 1 — Minimum Viable Knowledge:**
1. *Let's Get Real or Let's Not Play* PDF → ORDER methodology context
2. Microsoft Learn URLs → BXT framework grounding
3. SharePoint meeting notes → engagement history

**Phase 2 — Enhanced Quality:**
4. CRM connector (Dynamics 365) → account and opportunity data
5. Internal solution/pricing docs → realistic ORDER outputs
6. Prior BXT evaluations → scoring calibration

**Phase 3 — Scale:**
7. Responsible AI Standard v2 → Technology Feasibility guardrails
8. Competitor matrices and win/loss reports → sharper Decision Process
9. Successful output examples → "what good looks like" training data

---

## Source Frameworks

| Framework | Source | Used In |
|-----------|--------|---------|
| ORDER | *Let's Get Real or Let's Not Play* (2nd Ed.) — Khalsa & Illig | Meeting Discipline skill |
| BXT | Microsoft Business-Experience-Technology Framework | Use Case Evaluation skill |
| Capability Envisioning | Microsoft ISV Development Approach Selection | Future: Approach Selection skill |
| AI Decision Framework | Microsoft Three-Phase Decision Methodology | BXT scoring, intake filtering |
| Responsible AI Standard | Microsoft Responsible AI Standard v2 | Technology Feasibility guardrails |

---

## Getting Started

If you're a Microsoft Innovation Hub architect:

1. **For meeting prep:** Tell the agent *"Help me prepare for a meeting with [customer]"*
2. **For post-meeting:** Share your notes and say *"Summarize this meeting"*
3. **For use case evaluation:** Bring workshop outputs and say *"Evaluate these use cases using BXT"*

The agent handles the rest — selecting the right skill, applying the right template, and producing Hub-standard outputs.

---

> *"No Guessing — flag assumptions and push for verification."*
