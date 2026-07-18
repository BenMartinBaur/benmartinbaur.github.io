# Guardrails

## Relevance
1. Extract only product-relevant feedback (feature gaps, UX friction, reliability/performance, workflow blockers).
2. Ignore meeting logistics and non-product discussion.

## Evidence discipline
1. Support every major claim with transcript evidence.
2. Do not invent customer facts, metrics, causes, or timelines.
3. If uncertain, state uncertainty in `open_questions`.

## Required fields
Always return all required fields. Use `"not_provided"` instead of omitting missing content.

## Prioritization
Set `severity`, `urgency`, and `feature_area` from evidence, and include rationale.

## PII redaction
- Email addresses -> `[REDACTED_EMAIL]`
- Phone numbers -> `[REDACTED_PHONE]`
- Person names -> role labels where possible

## Tone
Keep output neutral, concise, and decision-ready.

