---
name: agent-canvas-designer
description: >
  Transform meeting transcripts, workshop notes, or customer engagement recordings into
  structured Agent Design Canvas documents following the Microsoft Copilot Studio framework.
  Use this skill whenever the user mentions "agent design", "design canvas", "agent canvas",
  "use case extraction", "copilot design", or provides a transcript (.vtt, .docx, .txt) and
  wants to define an agent from it. Also use when someone says "I had a workshop about building
  a copilot" or "design an agent from this meeting" or "create an agent spec from these notes".
  Produces Markdown (.md) and PowerPoint (.pptx) outputs — one canvas per agent, never a
  program-level document.
metadata:
  author: innovation-hub-munich
  version: "2.1"
  framework: https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/agent-design-canvas-framework
compatibility: Requires Python 3.10+ (defusedxml). PowerPoint output uses template from assets/.
---

# Agent Canvas Designer

Transform a customer engagement transcript into structured, implementable Agent Design Canvases
following the [Microsoft Copilot Studio design framework](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/agent-design-canvas-framework).

## Critical Rule: One Canvas = One Agent

**Each canvas must describe exactly ONE agent with ONE primary job.**

Why this matters: a canvas that describes multiple agents becomes a strategy document — useful for planning but impossible for a developer to implement directly. The whole point of the canvas is to produce something a team can build from. When a transcript discusses multiple agent opportunities (e.g., IT support agent, HR agent, store assistant), create **separate canvases** for each.

Test: "Could a developer build this agent from this canvas?" If the answer is "they'd need to build 3 different things," you need 3 canvases.

## Process

1. Read the provided transcript completely
2. Identify distinct agent opportunities discussed — list them
3. For each agent, extract information for all 10 canvas sections
4. Produce outputs per agent:
   - **Markdown** (`Agent-Canvas-<AgentName>.md`)
   - **PowerPoint** (`Agent-Canvas-<AgentName>.pptx`) — using the Innovation Hub branded template

## Canvas Sections

Each section has required sub-structure. Follow this precisely.

### 1. Goal

Start with outcomes, not features. The Jobs-To-Be-Done format forces clarity because it names the user, their need, and the measurable result — preventing vague goals like "improve IT" that no one can build against.

- **As a** \<specific user role\>
- **I need to** \<job to be done\>
- **So that** \<measurable outcome\>

Then provide:
- **Problem**: What specific pain exists today? (quantify: time, cost, error rate)
- **Target users**: Who interacts with this agent?
- **Success criteria**: 3-5 measurable criteria that prove the agent works (e.g., "90% of password reset requests resolved without human intervention")

⚠️ **Pitfall**: Don't describe a program ("consolidate 8 systems"). Describe what ONE agent does ("answer IT support questions and create tickets automatically").

### 2. Triggers

List the specific events that cause the agent to start working:

- **Event**: What happens (user message, email arrival, system event, schedule)
- **Data considerations**: What sensitive data is involved? What context must the trigger carry (user identity, record ID, location)? What system access is required?

⚠️ **Pitfall**: Triggers that depend on unpredictable user behavior (typing a specific keyword) are fragile. Prefer system events or structured entry points.

### 3. Channels

For each channel, specify:
- **Platform**: Where the agent is deployed (Teams, web, mobile, voice)
- **Constraints**: Screen size, input method, latency expectations, feature support (e.g., Adaptive Cards vs plain text)
- **User context**: How users access this channel in practice (on the shop floor, at a desk, on a personal phone)

⚠️ **Pitfall**: Don't choose channels based on technical convenience. Meet users where they already work.

### 4. Knowledge and Data

Document what the agent reasons over — distinguish:
- **Knowledge sources**: Documents, KB articles, policies the agent retrieves and reasons over
- **Structured data**: Databases, APIs, records the agent queries for specific facts
- **Quality expectations**: Freshness requirements, review cadence, ownership
- **Access boundaries**: What data is permissioned? Can the agent see more than the user should?

⚠️ **Pitfall**: Don't confuse "the company uses SAP" with "the agent reasons over SAP data." Only list what the agent actually accesses.

### 5. Tools and Integrations

Define what **actions** the agent performs — not just what systems exist. The distinction matters because workshop participants naturally talk about their tech stack ("we use SAP, ServiceNow, Intune"), but an agent canvas needs verbs: what does the agent *do* with those systems? Structure as:

- **What the agent does**: Concrete actions in verb form (parses email, creates ticket, looks up user, resets password, sends notification)
- **Systems**: Which APIs/connectors enable each action (ServiceNow API, Graph API, Entra ID)
- **Requirements**: Authentication model, rate limits, SLAs, error handling
- **Cross-team dependencies**: Who owns each system? Who do you call when the API breaks?

⚠️ **Pitfall**: Infrastructure tools (Terraform, Intune, AVD) are not agent tools unless the agent directly calls their APIs. Don't list the company's entire tech stack.

### 6. Flows and Orchestration

Structure into four explicit categories. This separation exists because mixing AI-flexible reasoning with deterministic logic in a single description leads to agents that hallucinate where they should follow rules, or follow rules rigidly where they should reason.

- **Agent responsibilities**: What the agent does autonomously (classify intent, look up KB, draft reply, create ticket)
- **Human responsibilities**: What requires human judgment (approve ticket closure, review escalations, update KB content, monitor audit logs)
- **Deterministic components**: Fixed logic that must always execute the same way (ticket number extraction regex, category routing rules, "no ticket found" fallback)
- **Flexible components**: Where the agent uses AI reasoning (natural language understanding, generative reply drafting, intent classification)

⚠️ **Pitfall**: Don't describe organizational processes (DNS migration, device rollout). Describe how the agent orchestrates its work.

### 7. Instructions and Behavior

Write as if programming the agent's brain. Sequenced, numbered instructions matter because LLMs follow step-by-step flows far more reliably than vague directives like "help the user." Include:

- **Role and scope**: One sentence defining who the agent is and what domain it operates in
- **Sequenced behavior**: Step-by-step numbered instructions (Step 1: Check KB → Step 2: Call ticketing API → Step 3: If unresolved, escalate)
- **Tool usage rules**: When to call which tool, validation before use ("Always verify ticket ID exists before returning status")
- **Failure handling**: What to do when a tool fails, KB has no answer, or input is ambiguous ("Don't guess. Respond with limitation and next step.")
- **Must-not-do list**: Explicit prohibitions (don't share internal IDs, don't give legal advice, don't close tickets without approval, don't fabricate information)
- **Tone and style**: Professional/casual, language, formatting rules

⚠️ **Pitfall**: "Help users with IT issues" is not an instruction. "Step 1: Search the KB for the user's exact error message. Step 2: If found, return the resolution with a citation link." is an instruction.

### 8. Agent Architecture

If multiple agents are involved, define delegation:

- **Parent agent**: The entry-point agent that routes requests
- **Child agents**: Specialized agents with clear responsibilities (KB Search Agent, Ticket Agent, Classification Agent)
- **Delegation boundaries**: What input does each child expect? When does the parent hand off? How are results returned?
- **Benefits**: Why this decomposition? (separation of duties, different permissions, team ownership)

For a single agent, describe its components and whether future decomposition is planned.

⚠️ **Pitfall**: Don't list every agent the company might build. Describe the architecture for THIS agent and its immediate collaborators.

### 9. Governance & Risk

Structure into:

- **Agent-specific risks**: What can go wrong with THIS agent? (misclassifies intent, returns wrong ticket, exposes data to unauthorized user, hallucinates KB article, over-automates sensitive action)
- **Mitigations**: Concrete countermeasures for each risk (RBAC, fallback flows, confidence thresholds, human approval gates)
- **Authentication & Authorization**: How does the agent authenticate? What can it read/write/delete? What is explicitly forbidden?
- **Auditability**: What is logged? (every action, tool call, refusal, escalation) How are logs reviewed?
- **Operational ownership**: Who owns this agent? Who reviews its behavior? What is the incident response process?

⚠️ **Pitfall**: Don't list organizational compliance requirements (NIS2, GDPR) without connecting them to specific agent behaviors. "NIS2 requires logging" → "Therefore, the agent logs every ticket creation with user ID, timestamp, and action taken."

### 10. Evaluation and Optimization

Structure into:

- **Test scenarios**: Specific input → expected output pairs that validate the agent works (e.g., "User asks 'my screen is frozen' → Agent returns KB article #1234 with restart steps")
- **Metrics**: Quantitative measures (% automated end-to-end, accuracy of ticket lookup, average response time, escalation rate, user satisfaction)
- **Telemetry**: What data to collect at runtime (every tool call, parse results, failures and retries, generated reply content for QA review, user feedback signals)
- **Optimization plan**: How will the agent improve? (review escalated cases weekly, retrain classification monthly, expand KB based on top unanswered questions)

⚠️ **Pitfall**: Don't define metrics you can't measure. "User satisfaction" requires a feedback mechanism in the design.

## Output Quality

- **Agent-specific**: Every statement must be about what THIS agent does, not what the company does
- **Implementable**: A developer should be able to build the agent from the canvas
- **Specific**: Use concrete system names, API endpoints, data fields — not vague references
- **Synthesized**: Same topic discussed multiple times → combine into one coherent section
- **Attributed**: Use blockquotes for direct transcript quotes that add clarity

## Handling Missing Information

If a section is **not discussed**, **ambiguous**, or **contradictory**:

1. Write "Not discussed in transcript" or summarize what was partially mentioned
2. Add item to the **Ambiguity & Open Items** table at document end
3. Mark with ⚠️

```markdown
| Section | Missing/Unclear Item | Notes | Suggested Follow-up |
|---------|---------------------|-------|---------------------|
| ⚠️ Triggers | Event source | "When something happens" — undefined | What system event triggers the agent? |
```

## Extracting Text from VTT Transcripts

For `.vtt` transcript files, use the extraction script to get clean text:

```bash
python scripts/extract_vtt.py <input.vtt> [output.txt]
```

This strips timestamps, speaker tags (`<v @1>`), segment IDs, and WEBVTT headers.
If no output file is given, prints to stdout.

## Generating the PowerPoint (.pptx)

**Automated workflow**: Use the bundled `scripts/generate_pptx.py` script to automate PPTX generation.

The template is at `assets/Agent-Design-Canvas.pptx` — a single-slide branded canvas with a 2-column, 6-row table. See [PowerPoint template reference](references/pptx-template.md) for detailed specs.

### Automated Workflow (Recommended)

```bash
python scripts/generate_pptx.py <canvas.md> <output.pptx> [--template <path>]
```

This script:
1. Extracts 10 canvas sections from the markdown file
2. Condenses each to 2–4 sentences
3. Updates the PPTX template XML with proper formatting
4. Repacks into a final PPTX file

No manual unpack→edit→clean→pack steps needed.

### Manual Workflow (Legacy)

If you need fine-grained control, use the **pptx skill** editing workflow:

1. **Copy template** to output location
2. **Unpack**: `python <pptx-skill>/scripts/office/unpack.py <copy>.pptx unpacked/`
3. **Edit** `unpacked/ppt/slides/slide1.xml`:
   - Replace the gray placeholder description text (color `#A5A5A5`, 10.5pt) in each cell with extracted canvas content
   - Keep bold section header text (11pt) as-is
4. **Clean**: `python <pptx-skill>/scripts/clean.py unpacked/`
5. **Pack**: `python <pptx-skill>/scripts/office/pack.py unpacked/ output.pptx --original <copy>.pptx`
6. **QA**: `python -m markitdown output.pptx` — verify all 10 sections have content, no placeholder text remains

### Template Cell Layout

| Row | Left Column | Right Column |
|-----|-------------|--------------|
| 1 | Use case description (Goal) — spans full width (gridSpan=2) | — |
| 2 | Triggers | Channels |
| 3 | Knowledge and data | Tools and integrations |
| 4 | Flows and orchestration | Instructions and behavior |
| 5 | Agent architecture | Governance & Risk Management |
| 6 | Evaluation and optimization — spans full width (gridSpan=2) | — |

### Key Rules

- Content for the PPTX must be a **condensed summary** (2-4 sentences per section), not the full markdown content
- Use `xml:space="preserve"` on `<a:t>` elements with leading/trailing spaces
- Smart quotes: use XML entities (`&#x201C;`, `&#x2019;`) not literal Unicode characters
- The template uses Innovation Hub theme (dark navy `#091F2C`, coral `#FFA38B`, Segoe UI fonts) — do not change the design

## Gotchas

- Transcripts are often in German — extract and output in the language of the transcript unless user specifies otherwise
- Auto-transcribed VTT files contain speaker tags (`<v @1>`) and timestamps — use `scripts/extract_vtt.py` to strip these before analysis
- Smart quotes in PPTX XML must be XML entities (`&#x2019;`), not literal Unicode — the pptx skill's clean step handles this
