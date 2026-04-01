# ORDER Skill — Contract

## Skill Identity

| Field | Value |
|-------|-------|
| **Skill Name** | ORDER Meeting Discipline |
| **Version** | 1.0 |
| **Source** | *Let's Get Real or Let's Not Play* (2nd Ed.) — Mahan Khalsa & Randy Illig |
| **Type** | Structured conversational skill (deterministic stages) |

## Purpose

Apply the ORDER consultative framework (Opportunity, Resources, Decision, Exact Solution, Results) to prepare for and summarize client meetings with verified understanding — eliminating guesswork.

## Modes

This skill operates in two modes:

### Mode 1: Meeting Preparation

| Field | Details |
|-------|---------|
| **Trigger phrases** | "Help me prepare for a meeting", "I have a meeting with...", "Prep for [client]", "Meeting prep" |
| **Trigger conditions** | User indicates an upcoming meeting or engagement |
| **Inputs** | Client/account name, meeting date, known attendees, any prior notes or CRM data |
| **Process** | Walk through O → R → D → E → R sequentially; ask probing questions per element; flag guesses |
| **Output** | Completed ORDER Meeting Preparation Sheet (structured template) |
| **Output template** | `Skills/ORDER/Prep-Template.md` |

### Mode 2: Meeting Summary

| Field | Details |
|-------|---------|
| **Trigger phrases** | "Summarize my meeting", "Here are my notes from...", "Meeting debrief", "What did we learn?" |
| **Trigger conditions** | User provides meeting notes, transcript, or verbal debrief |
| **Inputs** | Meeting notes, transcript, or verbal description of what happened |
| **Process** | Organize information into ORDER categories; compare against prep sheet if available; identify gaps |
| **Output** | Completed ORDER Meeting Summary with Gaps & Next Steps |
| **Output template** | `Skills/ORDER/Summary-Template.md` |

## Guardrails

| Rule | Behavior |
|------|----------|
| **No Guessing** | When user says "I think...", "probably...", "I assume..." → flag with ⚠️ and suggest a verification question |
| **Yellow Light Tracking** | Proactively surface risks (political dynamics, unclear authority, vague criteria, missing stakeholders) as 🟡 Yellow Lights |
| **Intent over Technique** | Remind user that genuine intent to help the client matters more than perfect framework execution |
| **Structured Output** | Always produce table/bullet outputs using ORDER headings — never free-form paragraphs |
| **Gaps & Next Steps** | Every output ends with a prioritized gap table and concrete action items |

## Handover Points

| From ORDER Element | Feeds Into | How |
|--------------------|-----------|-----|
| **Opportunity → Impact** | BXT → Business Viability | Quantified impact directly seeds BXT Business scoring |
| **Opportunity → Context** | BXT → Experience → Key Personas | Stakeholder and user context informs persona identification |
| **Decision → Stakeholders** | BXT → Experience → Change Resistance | Known decision dynamics inform adoption risk |
| **Exact Solution → Capabilities** | BXT → Technology Feasibility | Solution requirements feed technical feasibility assessment |
| **Results → Success Metrics** | BXT → Business → Business Value | Measurable outcomes validate business value scoring |
| **Yellow Lights** | Yellow Light Detection Skill | All flagged risks carry forward as cross-cutting inputs |

## Dependencies

- **Knowledge sources**: Book PDF, CRM connector, meeting history (SharePoint)
- **Templates**: Prep-Template.md, Summary-Template.md
- **Parent agent**: Innovation Hub Agent (orchestrator)
