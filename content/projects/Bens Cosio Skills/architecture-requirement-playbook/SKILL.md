---
name: architecture-requirement-playbook
description: Help technical architects create enterprise-ready architecture requirements documents from customer engagement transcripts and supporting documents. Use whenever the user provides workshop notes, briefing transcripts (.vtt, .docx, .txt), discovery artifacts, or asks for an architecture requirements document (ARD), technical requirements document, NFR baseline, governance-ready requirement set, or a good-vs-excellent quality uplift.
license: MIT
metadata:
  author: bebaur
  version: "1.1"
---

# Architecture Requirement Playbook

Create architecture requirements that are measurable, testable, traceable, and governance-ready.

## When to Use

- Drafting a new architecture requirements document (ARD)
- Reviewing existing requirements for enterprise quality
- Transforming customer engagement transcripts and workshop documents into architecture requirements
- Converting vague requirements into testable "shall" statements
- Defining NFR baselines (availability, performance, security, resilience, operability)
- Coaching teams on the difference between "good" and "excellent" requirements

## Core Principle

A requirement is enterprise-grade only if it can be:
1. Built
2. Verified
3. Governed
4. Traced to business outcomes

## Required Requirement Format

For each critical requirement, include:
- Requirement ID
- "Shall" statement
- Rationale
- Owner
- Priority
- Source
- Verification method
- Acceptance criteria (measurable pass/fail)

## Workflow

1. **Determine mode**: draft new ARD or assess/upgrade an existing document.
2. **Ingest source material**: transcript(s), customer notes, workshop outputs, and supporting documents.
3. **Capture context**: business outcomes, scope, constraints, stakeholder groups, compliance obligations.
4. **Structure requirements** into these layers:
   - Business
   - Stakeholder/User
   - Functional
   - Non-Functional
   - Technical/Architectural
   - Data
   - AI/Model (if applicable)
   - Constraints & Assumptions
5. **Quantify NFRs** with explicit thresholds (e.g., P95 latency, availability, RTO/RPO, control evidence).
6. **Add governance elements**:
   - Verification/evidence model
   - Traceability chain
   - Exception management
   - Architecture readiness exit criteria
7. **Score quality** using the Good vs Excellent rubric and list concrete gaps.
8. **Produce final output** using [ARD template](./assets/architecture-requirements-template.md).
9. **Save as markdown file** with naming convention:
   - `<YYYY-MM-DD>_<SystemOrProgram>_Architecture-Requirements.md`
   - Example: `2026-06-22_Customer360_Architecture-Requirements.md`

## Output Expectations

Always produce:
1. A complete ARD in markdown format
2. A concise "Good vs Excellent" assessment summary
3. A prioritized remediation list for quality gaps (if reviewing existing docs)
4. Explicit assumptions and validation actions when transcript/document evidence is incomplete

## Guardrails

These guardrails preserve quality and auditability:

- Do not leave critical requirements as non-testable prose; convert them to measurable "shall" form.
- Do not declare compliance without control/evidence mapping.
- Do not separate architecture requirements from operational verification (SLOs, runbooks, readiness checks).
- If key context is missing, state assumptions explicitly and attach validation actions.

If the user asks for a lightweight draft, provide it but clearly label which enterprise-grade elements are still missing.

## References

- [Good vs Excellent Rubric](./references/good-vs-excellent-rubric.md)
- [Standards Alignment Notes](./references/standards-alignment.md)
