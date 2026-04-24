---
title: "Ben's Cosio"
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

**One agent. Three skills. Zero guessing.**

Ben's Cosio is the single front door for Microsoft Architects preparing, running, and following up on customer engagements. It replaces the need for multiple standalone agents with one intelligent assistant that applies the right framework when it matters.

---

## What Problem Does This Solve?

Innovation Hub architects juggle multiple frameworks across the engagement lifecycle — discovery questions, meeting preparation, use case evaluation, solution design, stakeholder mapping, engagement sequencing. Each framework lives in a different document, a different tool, a different person's head.

Ben's Cosio brings them together. When you say *"help me prepare for a meeting,"* it activates the ORDER Prep Skill. When you say *"evaluate these use cases,"* it activates BXT scoring. When you say *"plan an engagement for [customer],"* it maps the full customer journey. The architect doesn't need to know which framework to use — the agent detects context and invokes the right skill.

---

## Architecture

The system follows a **skill choreography** pattern: one agent with three structured skills plus two inline capabilities. No sub-agents, no delegation — one front door, direct skill invocation.

```
┌──────────────────────────────────────────────────────┐
│              Ben's Cosio Agent                        │
│         (Routing + Inline Capabilities)              │
│                                                      │
│   Inline: Capability Envisioning | Yellow Light      │
├────────────────┬────────────────┬────────────────────┤
│    ORDER       │      BXT       │    Customer        │
│   Meeting      │   Use Case     │    Journey         │
│  Discipline    │  Evaluation    │   Planning         │
└────────────────┴────────────────┴────────────────────┘
         ▲               ▲               ▲
         │    Skill Handovers & Data     │
         └───────────────────────────────┘
```

### Skill Choreography Flow

Skills are not isolated — they feed each other:

| From | To | What Transfers |
|------|----|----------------|
| ORDER → Opportunity & Impact | BXT | Business Viability score context |
| ORDER → Exact Solution | BXT | Technology Feasibility inputs |
| ORDER → Decision & Stakeholders | BXT | Experience / Key Personas mapping |
| BXT → Accelerate to MVP | Capability Envisioning (inline) | Approach selection (Adopt/Extend vs Build Custom vs Build on Fabric) |
| BXT → Quadrant placement | Customer Journey | Journey stage progression |
| Customer Journey → Stage outputs | ORDER / BXT | Each stage maps to skill activations |
| Any Skill output | Yellow Light Detection (inline) | Cross-cutting risk and assumption scan |

---

## Core Skills

### 🤝 ORDER Meeting Discipline

**Status:** ✅ Shipped

Based on *Let's Get Real or Let's Not Play* (2nd Ed.) by Mahan Khalsa & Randy Illig.

**What it does:** Structures pre-meeting preparation, post-meeting summaries, coaching roleplay, and transcript processing using the ORDER framework — Opportunity, Resources, Decision Process, Exact Solution, Results.

**Modes:**
- **Meeting Preparation** — structured prep sheets with discovery questions
- **Meeting Summary** — organized debriefs with gap analysis and deal health checks
- **Coaching Mode** — interactive roleplay to practice your pitch before the meeting
- **Transcript Workflow** — paste a Teams Copilot transcript, get a structured ORDER summary

**Triggers:**
- *"Help me prepare for a client meeting"*
- *"Summarize my meeting notes"*
- *"Coach me before the meeting"*
- *"Here's the transcript"*

**Files:**
- Skill definition: [`skills/order-meeting/SKILL.md`](skills/order-meeting/SKILL.md)
- Prep template: [`skills/order-meeting/templates/prep-template.md`](skills/order-meeting/templates/prep-template.md)
- Summary template: [`skills/order-meeting/templates/summary-template.md`](skills/order-meeting/templates/summary-template.md)

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
- Skill definition: [`skills/bxt-evaluation/SKILL.md`](skills/bxt-evaluation/SKILL.md)
- Evaluation template: [`skills/bxt-evaluation/templates/evaluation-template.md`](skills/bxt-evaluation/templates/evaluation-template.md)

---

### 🗺️ Customer Journey

**Status:** ✅ Shipped

Based on the Microsoft Innovation Hub Engagement Model (4-stage pipeline).

**What it does:** Plans and sequences customer engagements through the Innovation Hub pipeline — from problem exploration through to technical proof. Assesses where the customer is, determines entry point, sequences workshops, and maps each stage to the appropriate skill activation.

**Stages:**
1. **Business Envisioning** → develops and prioritizes use cases (triggers BXT)
2. **Solution Envisioning** → agrees technical direction (triggers ORDER)
3. **Architecture Design** → architects the solution (triggers ORDER + BXT)
4. **Rapid Prototype** → proves capabilities (triggers ORDER)

**Triggers:**
- *"Plan an engagement for [customer]"*
- *"What workshops does [customer] need?"*
- *"Define a customer journey"*
- *"Where should we start with [customer]?"*

**Files:**
- Skill definition: [`skills/customer-journey/SKILL.md`](skills/customer-journey/SKILL.md)
- Journey template: [`skills/customer-journey/templates/journey-template.md`](skills/customer-journey/templates/journey-template.md)

---

### 🧭 Capability Envisioning *(Inline)*

Based on Microsoft's [Capability Envisioning](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/capability-envisioning) framework. Handled directly by the agent — no separate skill file.

**What it does:** After BXT scoring identifies high-priority use cases, helps select the right development approach — Adopt/Extend existing tools, Build Custom solutions, or Build on Fabric/platform capabilities.

---

### 🚦 Yellow Light Detection *(Inline)*

A cross-cutting risk scanner inspired by the "Yellow Light" concept from ORDER methodology. Handled directly by the agent — no separate skill file.

**What it does:** Scans any skill output for assumptions, missing information, stakeholder gaps, and engagement risks. Flags issues before they become blockers.

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
7. Innovation Hub engagement model docs → Customer Journey stage definitions

**Phase 3 — Scale:**
8. Responsible AI Standard v2 → Technology Feasibility guardrails
9. Competitor matrices and win/loss reports → sharper Decision Process
10. Successful output examples → "what good looks like" training data
11. Prior customer journey records → journey planning calibration

---

## Source Frameworks

| Framework | Source | Used In |
|-----------|--------|---------|
| ORDER | *Let's Get Real or Let's Not Play* (2nd Ed.) — Khalsa & Illig | ORDER Meeting Discipline skill |
| BXT | Microsoft Business-Experience-Technology Framework | BXT Use Case Evaluation skill |
| Capability Envisioning | Microsoft ISV Development Approach Selection | Inline in agent |
| AI Decision Framework | Microsoft Three-Phase Decision Methodology | BXT scoring, intake filtering |
| Responsible AI Standard | Microsoft Responsible AI Standard v2 | Technology Feasibility guardrails |
| Innovation Hub Engagement Model | Microsoft Innovation Hub 4-stage pipeline | Customer Journey skill |

---

## File Structure

```
Bens Cosio/
├── index.md                          # This file — project documentation
├── bens-cosio.agent.md               # Agent definition with routing and inline capabilities
├── Knowledge-Sources.md              # Single source of truth for all knowledge sources
└── skills/
    ├── order-meeting/
    │   ├── SKILL.md                  # ORDER Meeting Discipline skill definition
    │   └── templates/
    │       ├── prep-template.md      # Meeting preparation template
    │       └── summary-template.md   # Meeting summary template
    ├── bxt-evaluation/
    │   ├── SKILL.md                  # BXT Use Case Evaluation skill definition
    │   └── templates/
    │       └── evaluation-template.md # BXT evaluation template
    └── customer-journey/
        ├── SKILL.md                  # Customer Journey skill definition
        └── templates/
            └── journey-template.md   # Customer journey plan template
```

---

## Getting Started

If you're a Microsoft Innovation Hub architect:

1. **For meeting prep:** Tell the agent *"Help me prepare for a meeting with [customer]"*
2. **For post-meeting:** Share your notes and say *"Summarize this meeting"*
3. **For use case evaluation:** Bring workshop outputs and say *"Evaluate these use cases using BXT"*
4. **For engagement planning:** Say *"Plan an engagement for [customer]"* or *"Where should we start?"*
5. **For coaching:** After prep, say *"Coach me"* for interactive roleplay practice
6. **For transcripts:** Paste a Teams Copilot transcript and say *"Process these notes"*

The agent handles the rest — selecting the right skill, applying the right template, and producing Hub-standard outputs.

---

> *"No Guessing — flag assumptions and push for verification."*
