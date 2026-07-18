# Quality Rubric: Good vs Excellent Product Feedback

Use this rubric when evaluating transcript-derived output.

## Component-Level Criteria

### 1) What Help Is Needed
- **Good**
  - Clear request category (bug fix, UX improvement, feature ask, support gap).
  - Mentions the blocked action.
  - Includes at least one supporting quote.
- **Excellent**
  - Precise problem statement plus expected product behavior.
  - Request is scoped enough for a PM/engineering handoff.
  - Includes explicit trigger conditions (who, where, when) and acceptance hint.

### 2) Customer Scenario & Desired Outcome
- **Good**
  - Identifies actor and task.
  - States desired outcome in plain language.
  - Ties scenario to product context.
- **Excellent**
  - End-to-end flow with steps, constraints, and dependency points.
  - Distinguishes current behavior vs desired behavior.
  - Includes measurable success condition (time saved, fewer errors, throughput).

### 3) Customer Impact
- **Good**
  - Describes user pain and broad impact type.
  - Includes at least one consequence (delay, confusion, error risk).
- **Excellent**
  - Quantifies impact or provides high-confidence proxies (frequency, affected team size, revenue risk).
  - Notes business and user impact separately.
  - Includes severity rationale tied to transcript evidence.

### 4) Workaround Details
- **Good**
  - States whether a workaround exists.
  - Basic workaround steps and limitations.
- **Excellent**
  - Step-by-step workaround with effort/cost and failure conditions.
  - Explains why workaround is unsustainable or risky.
  - Captures workaround ownership and repeatability.

## Scoring
- Score each component `0-5`.
- Compute `overall_quality_score` as rounded average (1 decimal).
- Quality label:
  - `insufficient`: any required component missing or average < 2.5
  - `good`: average 2.5-4.1 and all required components present
  - `excellent`: average >= 4.2 with no component < 4

## Confidence
- `high`: direct transcript evidence for all key claims
- `medium`: minor inference needed, core claims evidenced
- `low`: missing evidence for major claims

