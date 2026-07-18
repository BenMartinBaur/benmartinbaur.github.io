# Product Feedback Capture Skill (Prompt/Spec)

This package defines a prompt/spec artifact for extracting high-quality product feedback from transcripts for product managers.

## Contents
- `SKILL.md` - Anthropic-style skill entrypoint with trigger description and workflow
- `references/` - rubric, guardrails, and output contract used by the skill
- `evals/evals.json` - seed eval prompts for iterative skill testing
- `skill_prompt.md` - standalone operational prompt version
- `output_schema.json` - required JSON contract
- `examples/` - sample transcripts and expected outputs
- `usage.md` - input/output usage guidance

## Decisions Applied
- Deliverable type: prompt/spec only (no runtime registration)
- Response shape: markdown summary + structured JSON
- Prioritization fields: severity, urgency, feature_area
- Privacy: basic PII redaction for names, emails, phone numbers
