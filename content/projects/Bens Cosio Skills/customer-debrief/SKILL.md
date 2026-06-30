---
name: customer-debrief
description: Generate a transcript-grounded customer workshop debrief after Innovation Hub engagements. Produces a branded customer-facing Word recap (.docx) with decisions, open items/risks, next steps, and an action table. Use whenever the user asks for customer recap/follow-up from workshop transcripts or notes.
license: MIT
metadata:
  author: bebaur
  version: "1.2"
---

# Customer Debrief

Create customer-ready workshop recaps that are evidence-based, concise, and on-brand.

## When to Use

- After Innovation Hub customer workshops
- After Solution Envisioning or Architecture Design sessions
- When asked to draft a customer follow-up recap from transcript/notes
- When a customer-facing summary document is needed in Word format

## Core Principle

**Evidence first, draft second.**  
Do not invent commitments, ownership, dates, decisions, or product claims.

## Inputs

- Transcript and/or workshop notes (required)
- Optional context artifacts in `input/`

If critical details are missing, continue and mark unresolved fields as `[TBC]`.

## Workflow

1. Determine workshop type and extract explicit outcomes from transcript evidence.
2. Build recap sections in the required structure (see Output Structure).
3. Apply transcript language rule (German transcript -> German output, otherwise English).
4. Produce a branded `.docx` using:
   - `assets/customer-debrief-template.docx`
   - `references/innovation-hub-brand.md`
5. Save the final document to `output/`.

## Output

- **Primary deliverable:** a Word document (`.docx`) in `output/`, one to two pages.
- **Language:** matches the transcript. A German transcript produces a German recap; otherwise English. Headings, body text, and the action table must all use the same language.
- **Tone:** professional, concise, and customer-appropriate.
- **Audience:** customer-facing only. Do not include internal-only notes or jargon.

## Output Structure (in-document)

1. **Engagement Overview** — customer, date(s), workshop purpose
2. **Attendees** — customer and Microsoft participants
3. **Objectives / Agenda**
4. **Key Discussion Points**
5. **Decisions & Agreements**
6. **Open Questions / Risks** (table format)
7. **Next Steps**
8. **Action Items** (table format)

The recap must end with **Next Steps** and **Action Items**.

## Table Requirements

### Open Questions / Risks
Use a markdown table with these columns before rendering to `.docx`:

| Open Item / Risk | Type (Open Item/Risk) | Impact | Owner | Due Date | Mitigation / Next Step | Evidence |
|---|---|---|---|---|---|---|

### Action Items
Use a table with at least:

| Action | Owner | Due Date | Status/Notes | Evidence |
|---|---|---|---|---|

## Quality Checks

Before finalizing:

1. Document exists in `output/` as `.docx`.
2. Language is consistent across headings, body, and tables.
3. Open Questions / Risks is a table (not bullets).
4. Action Items is a table with owner and due date (or `[TBC]`).
5. Claims are transcript-grounded; uncertainty is explicit.
6. Tone is customer-ready and excludes internal-only content.

## Guardrails

- Never fabricate attendees, decisions, owners, dates, or risks.
- Never leak internal strategy, commercial mechanics, or confidential notes.
- Never claim legal/compliance/security approval unless explicitly stated.
- If there is insufficient source content, ask for missing inputs instead of guessing.
