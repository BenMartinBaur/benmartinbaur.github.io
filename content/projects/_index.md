---
title: "Projects"
description: "Public projects, frameworks, and tools — from AI agent systems to content strategy."
date: 2026-02-28
layout: "page"
---

# Projects

Everything I build follows the same principle: **if it helped me, it might help someone else.** These projects sit at the intersection of what I do every day — customer conversations, architecture decisions, AI strategy — and the tools and frameworks that make those things repeatable.

Some are agent systems I use in production. Some are strategy documents that grew into their own thing. All of them were born from real work, not side projects for the sake of shipping.

---

## Active Projects

| Project | Pillar | What It Does | Status |
|---------|--------|--------------|--------|
| 🤖 [**Ben's Cosio**]({{< ref "/projects/Bens Cosio" >}}) | 🏗️ Build | Innovation Hub consulting agent — orchestrates ORDER meeting discipline and BXT use case evaluation across customer engagements | Active — 2 core skills |
| 🧠 [**Chief of Staff Agents**]({{< ref "/projects/chief-of-staff-agents" >}}) | 🗺️ Strategy | AI-powered content operations system that manages brand identity, publishing strategy, and blog operations for B3N.B4UR_ | Active — running in production |

## Documentation & References

These are reference guides for this blog platform itself — useful if you're building with Hugo and the Stack theme.

| Resource | Description |
|----------|-------------|
| 📝 [Markdown Syntax Guide]({{< ref "/projects/markdown-syntax-guide" >}}) | Comprehensive Markdown reference for Hugo content files — headings, tables, code blocks, math, footnotes |
| 🎨 [Rich Content & Shortcodes Guide]({{< ref "/projects/rich-content-shortcodes-guide" >}}) | Hugo Stack theme shortcodes — YouTube embeds, Mermaid diagrams, Gists, syntax highlighting, figure captions |

---

## Lessons Learned

Building these projects in public taught me a few things worth sharing:

### 1. Frameworks travel farther than features
The ORDER meeting framework and BXT scoring model aren't mine — they come from Mahan Khalsa, Microsoft's ISV team, and years of field practice. But packaging them as **structured agent skills** made them usable by anyone on the team, not just people who read the book. The lesson: *a good framework becomes 10x more powerful when you make it executable.*

### 2. AI works best as a system, not a chatbot
Ben's Cosio isn't one agent — it's skill choreography. The agent detects context (pre-meeting? post-workshop?) and invokes the right structured skill. Single-purpose chatbots hit a ceiling fast. **Orchestrated skills with clear handover points** scale to real workflows.

### 3. Brand is architecture too
The Chief of Staff work started as "fix some typos and pick a colour." It became a full brand system — content pillars, visual identity, publishing cadence, voice guidelines. Turns out content strategy has the same patterns as cloud architecture: you need foundations, guardrails, and clear interfaces between components.

### 4. Documentation is the product
Every project here has more documentation than code. That's intentional. The agent definitions, skill contracts, and knowledge source maps **are** the product — the AI just executes them. If you can't write down what your agent should do in plain English, the agent won't do it well either.

### 5. Ship with guardrails, not perfection
Ben's Cosio has two working skills and two marked "future." The Chief of Staff backlog has items explicitly deferred. Shipping incomplete-but-useful beats waiting for complete-and-never. The guardrail: *every shipped skill must have a contract, templates, and references. No exceptions.*

---

> *"If you can't explain it to a CTO and a Cloud Engineer, you don't understand it."*