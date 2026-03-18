---
layout: post
title: "How a Frontier Center of Excellence Works Together with a Cloud Center of Excellence"
description: "The CCoE builds the runway; the Frontier CoE flies the plane. Here's how the two work together — and where the tension points are."
date: 2026-03-05
image: featured.jpg
category: strategy
tags:
  - AI
  - Strategy
  - Center of Excellence
  - Leadership
reading_time: "5 min read"
---

As a Technical Architect in Microsoft's Innovation Hub and Office of the CTO, I sit right at the intersection where cloud platform strategy meets frontier AI ambition. I spend my days working with customers who've already invested years building mature Cloud Centers of Excellence — and who are now asking the same question: *"We've got the cloud part figured out. How do we bolt on an AI capability without breaking what works?"*

It's a question I hear in nearly every executive briefing. And honestly, it's the right one to ask. Most enterprises have spent the last decade building a **Cloud Center of Excellence (CCoE)** — the team that standardises landing zones, enforces guardrails, and keeps cloud costs in check. That investment paid off. Infrastructure is no longer the bottleneck.

But now a new wave is hitting the organisation: **frontier AI**. Generative models, agentic workflows, retrieval-augmented generation — capabilities that move faster than any cloud migration playbook ever anticipated. In response, a growing number of companies are standing up a **Frontier Center of Excellence** to govern, scale, and accelerate AI adoption.

From what I've seen working across industries, the question isn't whether you need both. You do. The question is **how they work together** — where responsibilities overlap, where they diverge, and where friction tends to show up if nobody is paying attention. Let me walk you through the model I use with customers.

## Cloud CoE vs. Frontier CoE

| | **Cloud CoE** | **Frontier CoE** |
|---|---|---|
| **Focus** | Cloud infrastructure, migration, operations, cost optimization | Frontier AI models, generative AI, agentic workflows |
| **Maturity** | Established discipline (~10+ years) | Emerging discipline (~2-3 years) |
| **Key outputs** | Landing zones, guardrails, IaC templates, FinOps | AI use-case pipelines, prompt libraries, model governance, evaluation frameworks |

## How They Collaborate

### 1. Foundation Layer (CCoE enables Frontier CoE)

This is the part I keep coming back to in conversations: **your Frontier CoE is only as strong as the cloud platform underneath it.** The CCoE provides the infrastructure backbone — compute, networking, identity, and security — that frontier AI workloads run on. Without a mature CCoE, a Frontier CoE can't operate at scale.

I've seen organisations try to skip this step. They spin up Azure OpenAI resources ad hoc, bypass networking controls, and hard-code API keys. It works for a demo. It falls apart at production. The CCoE has to be there first — GPU provisioning, private endpoints, managed identities, all of it.

### 2. Governance Alignment

Both CoEs share overlapping governance concerns, and in my experience this is where most of the confusion lives:

- **Data residency & sovereignty** — CCoE owns the cloud policy; Frontier CoE extends it to AI-specific data handling (training data, grounding data, model outputs)
- **Cost management** — CCoE handles FinOps; Frontier CoE adds AI-specific consumption tracking (token usage, inference costs). I've watched AI inference costs surprise more than one CFO — you need someone owning this from day one.
- **Security & compliance** — Shared responsibility for responsible AI guardrails layered on top of cloud security baselines

### 3. Operating Model

Here's the operating model I typically sketch on a whiteboard during customer sessions:

```
┌─────────────────────────────────┐
│       Enterprise Strategy       │
└──────────┬──────────────────────┘
           │
    ┌──────┴──────┐
    │             │
┌───▼───┐   ┌────▼────┐
│ CCoE  │◄──► Frontier│
│       │   │  CoE    │
└───┬───┘   └────┬────┘
    │             │
    └──────┬──────┘
           │
  ┌────────▼────────┐
  │  Product Teams  │
  │  / Business     │
  └─────────────────┘
```

- **CCoE** sets platform standards, landing zones, and self-service infrastructure
- **Frontier CoE** defines AI patterns, model selection guidance, and use-case qualification
- **Product teams** consume both — using CCoE-approved infrastructure with Frontier CoE-approved AI patterns

The key insight: these two CoEs aren't in a hierarchy. They're **peers** that feed into each other. I've seen it go wrong when the Frontier CoE reports into the CCoE and gets bottlenecked by infrastructure processes that weren't designed for the speed of AI experimentation.

### 4. Shared Practices

- **Inner-source model** — Both publish reusable assets (IaC modules from CCoE, AI accelerators/templates from Frontier CoE)
- **Federated champions** — Embedded specialists in business units who bridge both CoEs. This is the single most underrated pattern I've encountered — having someone in the business unit who speaks both "cloud" and "AI" changes everything.
- **Joint review boards** — Architecture reviews that cover cloud + AI dimensions together

### 5. Evolution Path

I've watched this play out across dozens of customers, and there's a pretty consistent pattern:

> **Phase 1:** AI experiments run ad hoc on cloud infra → CCoE handles everything
>
> **Phase 2:** AI demand grows → Frontier CoE forms as a sub-team within CCoE
>
> **Phase 3:** AI becomes strategic → Frontier CoE becomes a peer to CCoE with its own charter

Most of the organisations I work with today are somewhere between Phase 2 and Phase 3. If that's where you are — that's exactly the right time to be intentional about the relationship between these two teams.

## Key Tension Points to Manage

These are the friction points I see come up again and again:

- **Speed vs. control** — Frontier CoE teams want fast experimentation; CCoE teams enforce guardrails. A well-designed self-service platform resolves this. I always tell customers: if your developers need to file a ticket to provision an AI sandbox, you've already lost.
- **Talent overlap** — ML engineers need cloud skills and vice versa. Cross-training and rotation programs help. Some of the best AI architects I've worked with started as cloud infrastructure engineers.
- **Budget ownership** — AI inference costs can be significant. Clear chargeback models between both CoEs and consuming teams are critical. Don't let this become a surprise six months in.

---

**The short version: the CCoE builds the runway; the Frontier CoE flies the plane.** They need tight alignment on governance, shared tooling, and a common operating model to avoid duplication and friction. I've seen this model work — and I've seen what happens when it's missing. Get it right early.
