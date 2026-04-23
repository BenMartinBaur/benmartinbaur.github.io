---
layout: post
title: "Principles Over Preferences — How I Make Architecture Decisions Under Pressure"
description: "Great architecture decisions don't come from tools or trends — they come from principles. Here's the personal operating philosophy that guides every call I make under pressure."
date: 2026-03-19
draft: true
image: 2026-03-19-the-importance-of-principals-featured.jpg
category: real
tags:
  - Leadership
  - Strategy
  - Best Practices
reading_time: "7 min read"
series: "The Leadership Operating System"
series_order: 1
---

## TL;DR

The best architecture decisions don't come from tools or trends — they come from principles. Preferences are situational; principles are non-negotiable. Drawing from Michael Gervais's high-performance psychology and Toto Wolff's F1 leadership, here's how I built a personal operating philosophy that guides every decision under pressure.

---

## The Question That Changed How I Architect

A few years ago, I was in an architecture review. Stakeholders from security, networking, development, and finance — all with competing priorities. The development team wanted speed. Security wanted control. Finance wanted cost reduction. Networking wanted simplification.

Every option I proposed got challenged by at least two groups.

I walked out of that meeting exhausted and frustrated. Then a mentor asked me a question that fundamentally shifted how I approach architecture:

> "What are your principles? Not your preferences. Your *principles*."

I didn't have a good answer.

**Preferences** are situational — I *prefer* Terraform over Bicep. I *prefer* hub-spoke over Virtual WAN. These change with context, with tooling, with experience.

**Principles** are non-negotiable — they're the foundational commitments that guide every decision regardless of context. They're the *why* behind the *what*.

And I realized I'd been architecting from preferences, not principles.

---

## What High-Performance Psychology Teaches Architects

Dr. Michael Gervais — the high-performance psychologist who works with Olympic athletes, Fortune 50 CEOs, and notably, Microsoft's Satya Nadella — has built his entire practice around one central idea:

> **"If you can get your mind right, you can be at your best."**

His framework, *Finding Mastery*, is built on the concept of a **personal philosophy** — a clearly articulated set of principles that govern how you show up, make decisions, and perform under pressure.

Here's why this matters for architects:

**Architecture is not a technical discipline. It's a decision-making discipline.**

Every day, architects face decisions with:
- Incomplete information
- Competing stakeholder interests
- Time pressure
- Significant long-term consequences
- No clear "right answer"

Sound familiar? It should. It's the same pressure environment that elite athletes, F1 team principals, and military leaders operate in.

The best performers in those domains don't wing it. They operate from **principles**.

---

## The Architecture Principles Framework

Inspired by Gervais's personal philosophy work and two decades of enterprise architecture, here's the framework I now use:

### 1. Clarity Before Complexity

> Before I add anything to a design, I must be able to explain *why* in one sentence.

If I can't articulate the purpose of a component to a non-technical stakeholder in 15 seconds, I don't understand it well enough to architect it. Complexity is easy. Clarity is the hard part.

### 2. Guardrails, Not Gates

> My architectures should enable teams to move fast *within* boundaries, not require them to ask permission at every step.

This principle shapes everything from landing zone governance to CI/CD pipeline design. The goal is **autonomy within constraints** — like a formula racing track with barriers that keep cars on course without slowing them down.

As Toto Wolff described his Mercedes F1 leadership philosophy — it's "tough love and mediation." Set high standards, give people the freedom to perform, and intervene only when the safety barriers are hit.

### 3. Failure Is an Input, Not an Output

> I design for failure. I treat every failure as data. I never treat failure as a judgment.

Systems fail. Deployments fail. Architecture reviews fail. The principle isn't "don't fail" — it's "fail in a way that teaches you something."

This echoes Gervais's teaching that **fear and focus cannot coexist**. If you're afraid of failure, you're not focused on the architecture. You're focused on protecting your ego.

### 4. Secure by Default, Not Secure by Effort

> Security is never an afterthought. It's never a sprint task. It's a property of the architecture itself.

If following security best practices requires *extra effort* from development teams, the architecture has failed. Security should be the path of least resistance — managed identities instead of connection strings, private endpoints instead of public access, policy enforcement instead of manual review.

### 5. Decisions Are Documented, Not Just Made

> If a decision isn't written down, it wasn't made — it was assumed.

Architecture Decision Records (ADRs) are not bureaucracy. They're the institutional memory of your system. When someone asks "why is it built this way?" in two years, the ADR answers the question without relying on the architect who might have left the team.

---

## Why Principles Beat Best Practices

Here's the controversial take: **best practices are overrated.**

Best practices are contextual. What's "best" for a startup with 5 engineers is terrible for an enterprise with 500. What's "best" for a greenfield project is wrong for a brownfield migration. What's "best" in 2024 might be outdated in 2026.

Principles are **context-independent**. They work everywhere because they operate at a higher level of abstraction.

| | Best Practices | Principles |
|---|---|---|
| **Scope** | Specific to a technology or scenario | Universal across technologies |
| **Shelf life** | 2-3 years before they need updating | Decade+ if well-constructed |
| **Decision-making** | "Do this specific thing" | "Use this lens to evaluate options" |
| **Conflict resolution** | Doesn't help when practices conflict | Provides a hierarchy for trade-offs |
| **Adaptability** | Rigid — follow or don't | Flexible — applies to new situations |

---

## Learning from F1: How Toto Wolff Leads with Principles

Toto Wolff's Mercedes F1 team won **eight consecutive Constructors' Championships** (2014-2021). Harvard Business School wrote a case study on his leadership. What fascinated Professor Anita Elberse was:

> *"It's really difficult to find a team that has won what is effectively a world championship eight times in a row. Usually complacency sets in, or some other factor makes it impossible for the team to perform at the highest level."*

Wolff's secret wasn't technical superiority alone. It was **principled leadership**:

- **Radical transparency** — problems are shared openly, not hidden
- **Constructive conflict** — disagreement is expected and valued
- **Never satisfied** — wins are celebrated briefly, then dissected for improvement
- **Psychological safety** — Wolff has been public about his own mental health challenges, seeing a psychiatrist for over 500 hours. By being vulnerable first, he created space for his team to be honest about struggles

These aren't strategies. They're principles. And they work in architecture teams just as they work in pit lanes.

---

## Building Your Architecture Principles: A Practical Exercise

Here's the exercise I now run with every architecture team I work with:

### Step 1: List Your Last 10 Architecture Decisions
Write down the last 10 significant decisions your team made. Not the outcomes — the decisions themselves.

### Step 2: Ask "Why?" Three Times
For each decision, ask "why did we decide this?" three times. The first answer is usually tactical. The second is strategic. The third reveals the principle (or reveals that there wasn't one).

### Step 3: Find the Patterns
Group similar "third-level whys" together. You'll typically find 4-6 clusters. These are your emerging principles.

### Step 4: Articulate Each Principle in One Sentence
A principle that requires a paragraph to explain isn't a principle — it's a policy. Principles are simple enough to remember, clear enough to apply, and specific enough to resolve conflicts.

### Step 5: Test Against Future Decisions
Take an upcoming decision and apply your principles. Do they help you choose? Do they conflict with each other? Refine until they provide clear guidance.

---

## My Morning Practice: How Gervais's Mindset Routine Applies

Gervais teaches a morning mindset routine that I've adapted for architects:

1. **Take one deep breath** — focus on a long exhale. Clear the noise.
2. **Recall one architecture decision you're grateful for** — not because it was perfect, but because you learned something.
3. **Set an intention for HOW you want to show up today** — not *what* you'll build, but *how* you'll engage. As a listener? A challenger? A simplifier?
4. **Review your principles** — 30 seconds. Just read them. Anchor yourself.

> *"We have the power to dictate our own inner experience."* — Dr. Michael Gervais

Before I architect systems, I've learned to architect how I show up. Everything else follows from there.

---

## Key Takeaways

- **Principles** are non-negotiable foundations; **preferences** are contextual choices — know the difference
- High-performance psychology from Gervais and leadership from Wolff's F1 team apply directly to architecture
- Build **4-6 clear principles** that guide every architecture decision
- Principles beat best practices because they're **context-independent** and long-lasting
- **Document your principles** as the first Architecture Decision Record any team creates

## What's Next

In Part 2 of this series, I show what living by these principles produces: **[The 0.007% Pinnacle Effect — What Consistent Excellence Actually Looks Like](/page/_drafts/unstructured-ideas/2026-04-02-the-0007-pinnacle-effect/).**

---

*This is Part 1 of the **[The Leadership Operating System](/series/the-leadership-operating-system)** series. Next up: [The 0.007% Pinnacle Effect — What Consistent Excellence Actually Looks Like](/page/_drafts/unstructured-ideas/2026-04-02-the-0007-pinnacle-effect/).*
