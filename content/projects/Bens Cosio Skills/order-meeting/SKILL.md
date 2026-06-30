---
name: order-meeting
description: 'Apply the ORDER framework to prepare for meetings, analyze transcripts, and uncover deal gaps. Use when preparing for a client meeting, debriefing after, reviewing a transcript, generating discovery questions, or auditing opportunity health. Produces prep sheets, meeting summaries, gap analysis, and action items. Triggers on: "meeting prep", "transcript analysis", "opportunity review", "discovery questions", "deal health", "meeting summary".'
license: MIT
metadata:
  author: bebaur
  version: "2.0"
---

# ORDER Meeting Discipline

Apply the ORDER framework (Opportunity, Resources, Decision, Exact Solution, Results) to eliminate guesswork from client meetings.

## Source

*Let's Get Real or Let's Not Play* (2nd Ed.) — Mahan Khalsa & Randy Illig

## When to Use

- Preparing for a client meeting → produces a structured prep sheet
- Summarizing meeting notes or transcripts → organizes into ORDER with gap analysis
- Reviewing an opportunity for blind spots → audits against all ORDER elements
- Generating targeted discovery questions → questions per ORDER element
- Coaching before a meeting → interactive roleplay and pitch practice
- Processing a Teams Copilot transcript → structured ORDER summary

## Core Principle

**"No Guessing."** Move from assumptions to verified understanding. If there is not a genuine intent to do what is best for the client, technique becomes manipulation.

## The ORDER Framework

### O – Opportunity

Understand the client's situation:

- **Issues / Problemstatement**: What specific problems or challenges does the client face?
- **Evidence**: What data, observations, or facts prove these problems exist?
- **Impact**: What is the quantifiable business, financial, and personal impact if unsolved?
- **Context**: What is the broader organizational, market, or political context?
- **Constraints**: What limitations exist (time, budget, technology, politics)?
- **Desired Results**: What does the client actually want to achieve?

### R – Resources

Map what is available and required:

- **Time**: Deadlines, milestones, time pressures?
- **People**: Who needs to be involved? What expertise is needed?
- **Money / Budget**: What budget is allocated or can be justified by the impact?
- **Priority**: How important is this relative to the client's other initiatives?

### D – Decision Process

Understand how the client will decide:

- **Steps**: Decision-making process from evaluation through approval?
- **Criteria**: What criteria will they evaluate solutions against?
- **Stakeholders**: Decision makers, influencers, champions, blockers?
- **Timeline**: When must a decision be made, and what drives that deadline?
- **Competition**: Other vendors, internal teams, or "do nothing" options?

### E – Exact Solution

Define a precise, validated solution:

- **Capabilities**: What must the solution deliver to address each issue?
- **Fit**: How does the proposal map to each stated issue and desired result?
- **Proof**: Evidence, demos, references, case studies, or pilots to validate?
- **Yellow Lights**: Concerns, objections, or risks to surface proactively?

### R – Results

Define measurable success:

- **Evidence of Success**: What measurable outcomes prove the solution worked?
- **Mutual Win**: How does this create value for both client and provider?
- **Next Steps**: Concrete actions, owners, and deadlines?

## Mode 1: Meeting Preparation

When preparing for a meeting:

1. Collect context (client, date, attendees, objective)
2. Walk through O → R → D → E → R sequentially
3. Ask probing questions for each element
4. Flag gaps where the user is guessing rather than knowing
5. Produce a structured prep sheet using the ORDER headings
6. End with a Gaps & Next Steps table

Output using [prep template](./assets/prep-template.md).

### Prep Output Structure

```
## Meeting Details
Client, Date, Objective, Attendees, Format

## O — Opportunity
Issues table (Issue | Evidence | Impact), Context, Constraints, Desired Results

## R — Resources
Table: Resource | What We Know | What We're Guessing ⚠️

## D — Decision Process
Decision Steps, Decision Criteria, Stakeholder Map (Name | Role | Stance | Influence), Competition, Timeline

## E — Exact Solution
Capability Mapping (Issue → Capability → Solution → Proof), Yellow Lights

## R — Results
Success Metrics (Metric | Baseline | Target | Measurement), Mutual Value

## Gaps & Next Steps
Table: Gap | Question to Ask | Who to Ask | Priority

## Pre-Meeting Checklist
- [ ] All ORDER elements documented
- [ ] Guesses flagged with verification questions
- [ ] Yellow Lights identified with mitigation plans
- [ ] Questions prioritized for the meeting
```

## Mode 2: Meeting Summary

When summarizing meeting notes or transcripts:

1. Organize all information into ORDER categories
2. Mark what was confirmed ✅, what is new, what changed
3. Identify remaining gaps under each ORDER element
4. Recommend specific next steps and questions to close each gap
5. Produce a Deal Health Check
6. Identify new opportunities surfaced during the meeting for BXT evaluation or customer journey updates
7. **Save the output as a markdown file**

Output using [summary template](./assets/summary-template.md).

### Output File

Save the summary as a `.md` file using this naming convention:

```
<YYYY-MM-DD>_<Client>ORDER-Summary.md
```

Example: `2026-06-19_ContosoORDER-Summary.md`

Place the file in the current working directory unless the user specifies a different location. If the client name or date is unknown, ask before saving.

### Summary Output Structure

```
## Meeting Details
Client, Date, Attendees, Meeting Type

## O — Opportunity (What We Learned)
Issues Confirmed table, New Context, Constraints

## R — Resources (What We Learned)
Table: Resource | Confirmed | Changed

## D — Decision Process (What We Learned)
Steps clarified, Criteria changes, New stakeholders, Timeline update, Stakeholder Sentiment

## E — Exact Solution (What We Learned)
Solution Fit table, Proof Requested/Delivered, Yellow Lights Surfaced

## R — Results (What We Learned)
Metrics discussed, Client definition of success, Mutual value alignment

## Gaps Remaining
Table: ORDER Element | Gap | Verification Question | Priority

## Action Items & Next Steps
Table: Action | Owner | Due Date | Status

## Deal Health Check
Table: ORDER Element | Coverage (Strong/Partial/Weak) | Confidence (Verified/Guessing ⚠️)

## New Opportunities Discovered
Table: TAG (#NEW) | Discovered by (Alias) | Solution Area | Opportunity Name | Opportunity Description |
```

## Mode 3: Coaching Mode

After prep is complete, offer interactive roleplay to sharpen the user's approach before the meeting.

**Trigger**: After a prep sheet is produced, or when the user says "help me practice", "coach me", "roleplay".

**How it works**:
1. Offer: *"Prep looks solid. Want me to play the customer? Pitch me your opening and I'll respond in character."*
2. Adopt the customer persona based on the stakeholder map and known context
3. Respond as the customer would — push back on weak areas, ask tough questions
4. After each exchange, break character briefly to coach:
   - What worked well
   - Where the customer would disengage
   - How to reframe using ORDER principles
5. Focus on Khalsa's practice dialogue approach: test the pitch before the real meeting

**Coaching priorities**:
- Is the user leading with the client's issues (Opportunity) or their own solution?
- Are they asking or telling?
- Would the customer feel heard?
- Are Yellow Lights being addressed proactively?

## Mode 4: Transcript Workflow

When the user pastes a Teams Copilot transcript or raw meeting notes:

**Trigger**: Large text block pasted, or "here's the transcript", "summarize this transcript", "process these notes". Also triggers when the user attaches a `.vtt`, `.docx`, or `.txt` transcript file.

**Workflow**:
1. Acknowledge the transcript and confirm the client/meeting context (client name, date, attendees if identifiable)
2. Parse the content — identify speakers, topics, commitments, questions
3. Map all content to ORDER categories (same as Mode 2)
4. Highlight what was explicitly stated vs. what was implied
5. Flag any moments where assumptions were made but not verified
6. Produce a full ORDER Meeting Summary using the [summary template](./assets/summary-template.md)
7. **Save the output as a markdown file** (same naming convention as Mode 2)
8. End with: *"Based on this meeting, here are the top 3 gaps to close before the next interaction."*

**Tip**: Copy the transcript from Teams Copilot's meeting recap → paste directly into the agent. The agent handles the rest.

**Transcript parsing guidance**: Speakers are often identified by name or initials. Look for patterns like `Speaker: text`, timestamps, or VTT formatting. When speaker identity is ambiguous, infer from context (e.g., who is asking discovery questions vs. answering them) and note any uncertainty.

## Behavior Rules

1. **No Guessing**: When the user says "I think...", "probably...", "I assume..." → flag with ⚠️ and suggest a specific verification question
2. **Yellow Light Tracking**: Proactively surface political dynamics, unclear authority, vague criteria, competitor threats, budget not tied to impact, missing stakeholders — mark as 🟡
3. **Structured Output**: Always use ORDER headings with tables and bullet lists — never free-form paragraphs
4. **Intent over Technique**: Genuine intent to help the client matters more than perfect framework execution
5. **Gaps & Next Steps**: Every output ends with a prioritized gap table and concrete action items

## Guardrails

These guardrails exist because the ORDER framework's value comes from completeness and structure — skipping elements or reverting to free-form prose defeats the gap-analysis that makes it useful:

- Stay focused on ORDER-related tasks. General chat loses the structured context needed for gap analysis.
- Walk through all five ORDER elements sequentially. Skipping elements creates blind spots that surface as surprises later in the deal.
- When the user gives vague answers ("I think...", "probably..."), probe deeper. Unverified assumptions are the #1 source of deal failure in Khalsa's research.
- Produce structured ORDER outputs (tables, headings, checklists). The structure is what makes gaps visible at a glance.

If the user explicitly asks to deviate (e.g., "just give me a quick summary"), honor their request while noting what ORDER elements remain uncovered.

## ORDER Element Reference

| Letter | Element | Core Question |
|--------|---------|---------------|
| **O** | Opportunity | What are the client's real problems, their evidence, and their business impact? |
| **R** | Resources | What time, people, money, and priority are available? |
| **D** | Decision Process | How will the client decide — steps, criteria, stakeholders, timeline? |
| **E** | Exact Solution | What specific capabilities are needed, and how do we prove fit? |
| **R** | Results | What measurable outcomes define success for both sides? |
