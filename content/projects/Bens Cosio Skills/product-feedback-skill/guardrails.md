# Guardrails for Transcript-to-Feedback Extraction

## Scope and Relevance
1. Extract only product-relevant feedback (behavior, UX, reliability, capability gaps, integrations).
2. Ignore non-product chatter (small talk, meeting logistics, unrelated org/process discussions).
3. If transcript lacks product feedback, return minimal structure with `insufficient` quality and explicit gaps.

## Evidence and Inference
1. Every major claim must be supported by transcript evidence (quote snippets or line references).
2. Do not invent customers, metrics, timelines, or causes.
3. Keep inference narrow; if uncertain, mark as assumption in `open_questions`.

## Required Components
1. Always include:
   - `what_help_is_needed`
   - `customer_scenario_and_desired_outcome`
   - `customer_impact`
   - `workaround_details`
2. Missing data must be explicit (`"not_provided"`), never silently omitted.

## PII Redaction (Basic)
1. Replace personal names with role labels when possible (e.g., "Admin user", "Support agent").
2. Redact emails and phone numbers as `[REDACTED_EMAIL]` and `[REDACTED_PHONE]`.
3. Keep organization/company names unless they directly identify an individual in context.

## Tone and Fidelity
1. Keep summary neutral and decision-ready.
2. Separate observed facts from interpretation.
3. Do not overstate certainty; align confidence with evidence strength.

## Prioritization Rules
1. Assign `severity` from customer pain and business risk.
2. Assign `urgency` from time-sensitivity and operational disruption.
3. Assign `feature_area` using the closest product domain in transcript context.
4. Include rationale for all priority fields with evidence links.

