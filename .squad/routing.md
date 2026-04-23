# Work Routing

How to decide who handles what.

## Routing Table

| Work Type | Route To | Examples |
|-----------|----------|----------|
| Brand alignment & backlog | Toto | Pillar checks, backlog prioritization, cadence tracking, brand drift |
| Leadership & mindset content | Michael | "Real" pillar review, performance posts, habit posts, personal philosophy |
| Content review & values | Simon | DEI review, tone check, generational inclusivity, voice alignment |
| Writing & drafting | Quill | Draft posts, edit copy, front matter, taxonomy, content production |
| Meta-journey content | Meta | Document squad sessions, write about AI collaboration journey |
| Hugo templates & layouts | Hugo | Shortcodes, partials, theme tweaks, hugo.toml, SCSS, visual identity |
| Technical architecture review | John | Build post accuracy, Azure services, security, scalability, edge cases |
| Content review pipeline | Michael → Simon → Toto | Leadership content flows through all three reviewers |
| Build content pipeline | Quill → John → Simon → Toto | Technical content gets architecture review then values + brand check |
| General content pipeline | Simon → Toto | Non-leadership content gets values review then brand alignment |
| Session logging | Scribe | Automatic — never needs routing |

## Issue Routing

| Label | Action | Who |
|-------|--------|-----|
| `squad` | Triage: analyze issue, assign `squad:{member}` label | Lead |
| `squad:{name}` | Pick up issue and complete the work | Named member |

### How Issue Assignment Works

1. When a GitHub issue gets the `squad` label, the **Lead** triages it — analyzing content, assigning the right `squad:{member}` label, and commenting with triage notes.
2. When a `squad:{member}` label is applied, that member picks up the issue in their next session.
3. Members can reassign by removing their label and adding another member's label.
4. The `squad` label is the "inbox" — untriaged issues waiting for Lead review.

## Rules

1. **Eager by default** — spawn all agents who could usefully start work, including anticipatory downstream work.
2. **Scribe always runs** after substantial work, always as `mode: "background"`. Never blocks.
3. **Quick facts → coordinator answers directly.** Don't spawn an agent for "what port does the server run on?"
4. **When two agents could handle it**, pick the one whose domain is the primary concern.
5. **"Team, ..." → fan-out.** Spawn all relevant agents in parallel as `mode: "background"`.
6. **Anticipate downstream work.** If a feature is being built, spawn the tester to write test cases from requirements simultaneously.
7. **Issue-labeled work** — when a `squad:{member}` label is applied to an issue, route to that member. The Lead handles all `squad` (base label) triage.
