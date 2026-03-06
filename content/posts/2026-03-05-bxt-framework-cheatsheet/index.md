---
layout: post
title: "The BXT Framework Cheatsheet — Business, Experience, Technology"
description: "A practical cheatsheet for applying Microsoft's BXT Framework in customer engagements. Score viability, desirability, and feasibility before you build."
date: 2026-03-05
image: featured.jpg
category: ai
tags:
  - AI
  - Strategy
  - Leadership
  - Framework
  - Customer Engagement
reading_time: "7 min read"
---

Welcome to the boardroom! Every week I sit in rooms — physical and virtual — where customers pitch AI use cases. Some are brilliant. Some are solutions looking for a problem. The hardest part of my job isn't building the thing — it's making sure we're building the *right* thing.

That's where the **BXT Framework** comes in. BXT stands for **Business, Experience, and Technology** — a tri-pillar framework developed by Microsoft to evaluate AI and digital innovation initiatives before committing development resources. It's designed to answer one question: *Is this use case worth building?*

I use it in nearly every customer engagement in Microsoft's Innovation Hub and Office of the CTO. This post is the cheatsheet I wish I'd had when I started.

---

## TL;DR — The BXT Scoring Matrix

| Pillar | Sub-component | Key Question | Score (1-5) |
|--------|--------------|--------------|:-----------:|
| **Business** | Executive Strategy Alignment | Does this align with the org's mission and strategic priorities? | |
| | Business Value | What revenue, cost savings, or productivity gains does this unlock? | |
| | Change Management Timeframe | How long until this is in production and generating value? | |
| **Experience** | Key Personas | Who are the end-users and stakeholders? Are they identified and engaged? | |
| | Value Proposition | Why would someone use this over the current alternative? | |
| | Change Resistance | How willing are users to adopt this new way of working? | |
| **Technology** | Implementation & Operations Risks | What technical risks exist and how will we mitigate them? | |
| | Sufficient Safeguards | Are security, compliance, and responsible AI guardrails in place? | |
| | AI/LLM Fit | Is this problem actually suited for AI/LLM capabilities? | |

> **How to score:** Rate each sub-component 1-5. Average the three sub-components per pillar. Combine with a Strategic Fit score (1-5) to plot your use case on the prioritization chart.

---

## The Intake Filter — Before You Even Start

Before opening the BXT scorecard, I run every idea through three gate questions. If the customer can't answer these clearly, we pause and reframe before going further.

| # | Gate Question | Why It Matters |
|---|--------------|----------------|
| 1 | **What business outcome am I trying to achieve?** | If the outcome is unclear, no technology will fix it. Rewrite the problem statement. |
| 2 | **What user experience delivers that outcome?** | Prototype the interaction first. Does it actually need a chatbot, or just a smarter search bar? |
| 3 | **Does a tool already exist?** | Check existing tools first. Can Microsoft 365 Copilot or a standard SaaS feature solve this with zero coding? Start rigid (SaaS), move to configuration (Low-Code) only if it fails, move to construction (Pro-Code) only if configuration hits a wall. |

---

## Pillar 1: Business (Viability)

*"Is it worth doing?"*

The Business pillar determines whether the use case has real financial and strategic value. I break every conversation here into three threads:

### Executive Strategy Alignment

| Question | What I'm Listening For |
|----------|----------------------|
| Does this use case align with your organization's stated strategic priorities? | Clear link to OKRs, board-level initiatives, or published strategy |
| Who is the executive sponsor? | Named individual with budget authority — not "the team" |
| Who are the primary stakeholders accountable for outcomes? | People who will be measured on success, not just interested parties |
| Are the relevant teams identified and ready to engage? | Engineering, product, compliance, and business unit alignment |

### Business Value

| Question | What I'm Listening For |
|----------|----------------------|
| What is the ROI beyond general productivity gains? | Quantifiable cost savings, revenue increase, or risk reduction |
| Is this a core product capability, an extension, or an add-on? | Monetization clarity — free feature vs. revenue driver |
| What is the Total Cost of Ownership vs. the expected benefit? | Realistic cost model including inference, maintenance, and support |
| How does this compare to competing investment priorities? | Opportunity cost awareness |

### Change Management Timeframe

| Question | What I'm Listening For |
|----------|----------------------|
| When will this be ready for internal testing? | Realistic milestone, not aspirational |
| When will it reach pilot users? When will it generate revenue? | Path to value with concrete dates |
| What is the impact on existing operations during rollout? | Low-impact quick wins vs. high-disruption transformations |
| What resources are required beyond the development team? | Training, change management, documentation needs |

---

## Pillar 2: Experience (Desirability)

*"Do people actually want this?"*

This is the pillar I see customers skip most often. They build something technically impressive that nobody uses. Every time.

### Key Personas

| Question | What I'm Listening For |
|----------|----------------------|
| Who are the end-users? Who are the internal stakeholders? | Named personas, not "everyone" |
| What does a day in the life of your target user look like? | Understanding of current pain points and workflows |
| Have you talked to actual users about this idea? | Evidence of user research, not assumptions |
| Who will champion adoption inside the organization? | Internal advocates who will drive usage post-launch |

### Value Proposition

| Question | What I'm Listening For |
|----------|----------------------|
| What is the motivating reason to use this over the current alternative? | A compelling "10x better" story, not a marginal improvement |
| Does this solve a painful, frequent problem? | Pain + frequency = adoption. Nice-to-have = shelf-ware |
| How will you measure adoption? | Defined KPIs: DAU, task completion rate, time saved |
| Does this fit naturally into existing workflows? | Embedded in the flow of work vs. "yet another tool" |

### Change Resistance

| Question | What I'm Listening For |
|----------|----------------------|
| How willing are your users to adopt new tools and processes? | Honest assessment, not optimism |
| What has happened with previous technology rollouts? | Track record of adoption success or failure |
| What training and enablement is planned? | Investment in change management, not just deployment |
| Are there cultural or organizational barriers to adoption? | Union rules, compliance culture, "we've always done it this way" |

---

## Pillar 3: Technology (Feasibility)

*"Can we actually build this?"*

### Implementation & Operations Risks

| Question | What I'm Listening For |
|----------|----------------------|
| What are the primary technical risks? | Data quality, integration complexity, latency requirements |
| What is the team's current skillset? Do you need to hire, train, or partner? | Honest capability assessment |
| Is the required data accessible and governable? | Data exists, is clean, and can be used within compliance boundaries |
| Is the infrastructure and compliance posture ready? | Landing zones, networking, identity, and security baselines in place |

### Sufficient Safeguards

| Question | What I'm Listening For |
|----------|----------------------|
| What security and compliance requirements apply? | Industry regulations, data residency, access controls |
| How will you handle responsible AI concerns? | Content filtering, bias mitigation, transparency, human oversight |
| What data protection and access controls are in place? | Encryption, RBAC, audit logging |
| Have legal and compliance teams reviewed the use case? | Sign-off from legal, not just engineering approval |

### AI/LLM Fit

| Question | What I'm Listening For |
|----------|----------------------|
| Is this problem actually suited for AI/LLM? | Not everything needs GenAI — sometimes a rules engine or search index is enough |
| What happens when the model is wrong? | Tolerance for hallucination, error handling strategy |
| What is the expected accuracy threshold? | "Good enough" defined before build, not after |
| Have you considered non-AI alternatives? | Cost-benefit of AI vs. traditional automation |

---

## Scoring & Prioritization

Once you've walked through all three pillars, calculate:

1. **Strategic Fit Score** (1-5): Based on business objective, key results, and stakeholder readiness
2. **Business Impact Score**: Average of the three Business sub-component scores
3. **Experience Score**: Average of the three Experience sub-component scores
4. **Technology Score**: Average of the three Technology sub-component scores

Then plot on two axes:

- **X-axis: Degree of Executional Fit** = Mean of (Experience Score + Technology Score)
- **Y-axis: Degree of Strategic Business Impact** = Mean of (Strategic Fit Score + Business Score)

### The Four Quadrants

```
                    High Strategic Business Impact
                              │
                 Research      │     Accelerate
              (high value,     │      to MVP
              low feasibility) │  (high value,
                              │   high feasibility)
         ─────────────────────┼─────────────────────
                              │
                 Shelve        │     Incubate
              (low value,      │  (low value,
              low feasibility) │   high feasibility)
                              │
                    Low Strategic Business Impact
          Low Executional Fit ◄─────► High Executional Fit
```

| Quadrant | Action |
|----------|--------|
| **Accelerate to MVP** | High strategic impact + high feasibility. Invest and build. |
| **Incubate** | Technically feasible but low strategic impact. Prototype and test in controlled environments. Refine to align with strategy. |
| **Research** | High potential value but currently unfeasible or low demand. Investigate problem space, user needs, and market conditions. |
| **Shelve** | Low impact + low feasibility. Revisit only if circumstances change significantly. |

---

## Quick Reference: The One-Pager

Use this in your next customer workshop:

```
┌──────────────────────────────────────────────────┐
│              BXT FRAMEWORK SCORECARD             │
├──────────────────────────────────────────────────┤
│                                                  │
│  USE CASE: ___________________________________   │
│  DATE: ____________  SPONSOR: _______________    │
│                                                  │
│  STRATEGIC FIT (1-5): [ ]                        │
│                                                  │
│  ┌─ BUSINESS (Viability) ──────────────────┐     │
│  │  Executive Strategy Alignment:    [ ]/5 │     │
│  │  Business Value:                  [ ]/5 │     │
│  │  Change Management Timeframe:     [ ]/5 │     │
│  │  Average:                         [ ]/5 │     │
│  └─────────────────────────────────────────┘     │
│                                                  │
│  ┌─ EXPERIENCE (Desirability) ─────────────┐     │
│  │  Key Personas:                    [ ]/5 │     │
│  │  Value Proposition:               [ ]/5 │     │
│  │  Change Resistance:               [ ]/5 │     │
│  │  Average:                         [ ]/5 │     │
│  └─────────────────────────────────────────┘     │
│                                                  │
│  ┌─ TECHNOLOGY (Feasibility) ──────────────┐     │
│  │  Implementation & Ops Risks:      [ ]/5 │     │
│  │  Sufficient Safeguards:           [ ]/5 │     │
│  │  AI/LLM Fit:                      [ ]/5 │     │
│  │  Average:                         [ ]/5 │     │
│  └─────────────────────────────────────────┘     │
│                                                  │
│  STRATEGIC BUSINESS IMPACT:  [ ]/5               │
│  (Strategic Fit + Business avg) / 2              │
│                                                  │
│  EXECUTIONAL FIT:            [ ]/5               │
│  (Experience avg + Technology avg) / 2           │
│                                                  │
│  RECOMMENDATION: □ Accelerate  □ Incubate        │
│                  □ Research    □ Shelve           │
│                                                  │
└──────────────────────────────────────────────────┘
```

---

## How I Use This in Practice

A few things I've learned using this framework across dozens of customer engagements:

1. **Never skip the Intake Filter.** If you can't articulate the business outcome in one sentence, you're not ready for a scorecard. Go back to the whiteboard.

2. **Score with the customer, not for the customer.** The most valuable part of BXT isn't the numbers — it's the conversation that produces them. Score together in the room. Disagreements between stakeholders surface critical misalignment early.

3. **Use it to kill bad ideas early.** That's not failure — that's saving six months and a million dollars. If any pillar scores below 2, pause. Reshape or shelve.

4. **Pair BXT with the Microsoft AI Decision Framework.** BXT is Phase 1. Once a use case scores well, move into the [nine critical technology questions](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html) to select the right platform and architecture.

5. **Revisit quarterly.** A use case shelved today might be ready to accelerate in six months. Conditions change — data becomes available, team skills grow, budgets shift. Keep the scorecard alive.

---

## Sources & Further Reading

- [Business Envisioning (BXT Framework) — Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/business-envisioning)
- [Microsoft AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/)
- [Capability Envisioning — Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/capability-envisioning)
- [CAF AI Adoption — Microsoft Learn](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/ai/)
- [Microsoft Responsible AI Standard v2 (PDF)](https://msblogs.thesourcemediaassets.com/sites/5/2022/06/Microsoft-Responsible-AI-Standard-v2-General-Requirements-3.pdf)
