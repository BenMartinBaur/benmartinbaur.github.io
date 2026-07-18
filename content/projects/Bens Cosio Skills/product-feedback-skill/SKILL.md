---
name: product-feedback-capture
description: Extract high-quality product feedback from customer transcripts for product managers. Use this skill whenever the user asks to analyze a call transcript, interview notes, or customer conversation to identify product gaps, customer outcomes, impact, workaround pain, prioritization, or PM-ready evidence summaries — even if they do not explicitly mention "feedback analysis."
---

# Product Feedback Capture

Use this skill to transform raw transcript text into decision-ready product feedback.

## What this skill produces
1. A concise PM-facing markdown summary.
2. A strict JSON payload with:
   - `what_help_is_needed`
   - `customer_scenario_and_desired_outcome`
   - `customer_impact`
   - `workaround_details`
   - `priority` (`severity`, `urgency`, `feature_area`, `rationale`)
   - `quality_assessment` and `evidence`
   - `open_questions`

## Why this structure matters
- PMs need fast triage plus structured data for tracking.
- Product signals are weak unless tied to direct evidence.
- Distinguishing **good** from **excellent** feedback prevents over-prioritizing vague requests.

## Workflow
1. Read the transcript and isolate product-relevant statements.
2. Extract the four required components.
3. Score quality using `references/rubric.md`.
4. Enforce evidence and safety constraints from `references/guardrails.md`.
5. Emit output in the contract described by `references/output-contract.md`.

## Report format
Always output in this exact order:

```markdown
## PM Summary
- ...

## Structured Output (JSON)
{ ... }
```

## Handling uncertainty
- Keep inferences narrow and explicit.
- If required details are missing, set value to `"not_provided"` and add targeted follow-up questions.
- Never invent metrics, customer attributes, or root causes.

## PII handling
Apply basic redaction:
- Emails -> `[REDACTED_EMAIL]`
- Phone numbers -> `[REDACTED_PHONE]`
- Personal names -> role labels where possible

## Example quality bar
- **Good**: clear request and customer pain, with at least one concrete impact signal.
- **Excellent**: specific scenario, quantified impact, explicit desired outcome, and actionable workaround limitations.

## References
- Rubric: `references/rubric.md`
- Guardrails: `references/guardrails.md`
- Output contract: `references/output-contract.md`
- Seed eval prompts: `evals/evals.json`

