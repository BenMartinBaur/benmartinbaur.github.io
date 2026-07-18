# Output Contract

Return markdown summary plus one JSON object.

## Markdown section
```markdown
## PM Summary
- 4-8 concise bullets
```

## JSON section
JSON must include:

- `summary_markdown` (string)
- `feedback` (object)
  - `what_help_is_needed` (string)
  - `customer_scenario_and_desired_outcome` (string)
  - `customer_impact` (string)
  - `workaround_details` (string)
  - `priority` (object)
    - `severity`: low|medium|high|critical
    - `urgency`: low|medium|high|immediate
    - `feature_area`: string
    - `rationale`: string
  - `quality_assessment` (object)
    - `label`: insufficient|good|excellent
    - `overall_quality_score`: 0-5
    - `component_scores`: object with all four required components scored 0-5
    - `confidence`: low|medium|high
  - `evidence`: array of `{ quote, supports[] }`
  - `open_questions`: array of strings

If transcript signal is weak, set quality to `insufficient` and provide targeted open questions.

