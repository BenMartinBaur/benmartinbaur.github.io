# Usage

## Input
Pass a transcript as plain text.

Recommended minimum:
- Who is speaking (even rough labels)
- Concrete customer statements
- Any metrics, frequency, timeline references

## Output
The skill returns:
1. PM summary in markdown
2. Structured JSON aligned to `output_schema.json`

## Interpretation
- Use `quality_assessment.label` to triage:
  - `excellent`: ready for backlog/PRD intake with minimal follow-up
  - `good`: usable but may require follow-up questions
  - `insufficient`: do not prioritize yet; gather missing evidence
- Use `open_questions` to guide next customer conversation.

## Limitations
- Transcript quality directly affects extraction quality.
- Ambiguous statements can reduce confidence.
- Basic PII redaction is limited to names/emails/phones.

