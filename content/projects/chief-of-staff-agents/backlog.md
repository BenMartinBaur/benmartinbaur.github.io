# Chief of Staff Agents — Backlog

Items the AI Chief of Staff team will execute, ordered by priority.

---

## 🔴 High Priority

### ~~Add CTA to every post~~ ✅ DONE
- ~~Add LinkedIn follow link + RSS subscribe to the footer of every post~~
- ~~Consider a Hugo partial template for consistent CTA block~~
- Built and injected into all posts via layout override (`layouts/_partials/article/components/cta.html`). LinkedIn + RSS buttons with branded styles (Coral Energy light / Soft Lavender dark).

### Update LinkedIn profile
- Sync bio with brand positioning statement
- Add blog link prominently in About section
- Update headline to match one-liner: "Technical Architect @ Microsoft CTO Office · Turning AI strategy into architecture that ships"
- **Why:** LinkedIn is the primary discovery channel; profile must match brand

### Resume LinkedIn posting
- Bridge the 4-year article gap (last article: March 2022)
- Start with 3x/week short-form posts (excerpts, hot takes, framework snippets)
- Republish 1 blog post as LinkedIn article per month
- **Why:** 8K followers see nothing; algorithm rewards consistency

### ~~Content pillar rebalance~~ ✅ DONE
- Added 3 new posts (1 Build, 1 Strategy, 1 Real). Real pillar now 21% → 32% after unstructured ideas are published.

### ~~LinkedIn strategy~~ ✅ DONE
- Comprehensive LinkedIn Top Voice strategy produced (`.squad/agents/toto/linkedin-top-voice-strategy.md`).

### ~~Squad infrastructure~~ ✅ DONE
- 9-agent squad operational with charters, routing table, and review pipelines.

---

## 🟡 Standard Priority

### ~~Create branded featured image template~~ ✅ DONE
- ~~Design consistent template: dark navy gradient + coral accent line + white title text~~
- ~~Apply to all existing and future posts~~
- All 14 posts now have `featured.jpg` files following the 3-pillar template system (Build = dark blue, Strategy = coral→purple, Real = lavender watercolour).

### ~~Add tagline to blog header~~ ✅ DONE
- ~~Add "Where Strategy Meets the Stack" as subtitle in hugo.toml~~
- Brand renamed from "The Architect" to **B3N.B4UR_**
- Tagline set to "From the server room to the boardroom"
- Logo: Space Grotesk Bold, numbers 3 & 4 in Coral Energy (#F96167)
- Favicon: BB

### Write anchor post
- Title: "What This Blog Is About & Who It's For"
- Pin to homepage or link prominently
- Covers: who Ben is, the three content pillars, what readers can expect
- **Why:** New visitors need orientation; About page is too buried

### ~~Fix "Business Envisioning Cheatsheet" post~~ ✅ DONE
- ~~`content/posts/2026-04-01-business-envisioning-cheatsheet/index.md` has no front-matter~~
- ~~Add proper YAML front-matter (title, date, category: strategy, tags)~~
- All posts now have correct `category` (singular), `reading_time` (string), `description`, and `layout: post` as part of full front matter standardisation pass.

### Structure unstructured ideas into publishable drafts
- 8 unstructured ideas remaining; 3 content series mapped
- Convert each idea into a full draft with front matter, featured image, and pillar assignment
- **Why:** Pipeline of ideas exists but won't generate value until published

### Run Simon DEI review pipeline on all new content
- Route all new and recently added posts through Simon's DEI review
- **Why:** Ensures inclusive language and perspective across all published content

### Implement LinkedIn First 30 Days execution plan
- Execute the phased rollout from the LinkedIn Top Voice strategy
- **Why:** Strategy is produced; execution is the next step to rebuild LinkedIn presence

### John technical review of remaining Build posts
- AVD networking post and W365 Agents post need technical accuracy review
- **Why:** Build pillar posts carry reputational risk if technically inaccurate

### Publish squad journey meta post after Simon review
- Write and publish a meta post documenting the AI squad experiment
- Route through Simon DEI review before publishing
- **Why:** The squad process itself is compelling content for the Real pillar

---

## 🔴 H2 2026 Content Program (NEW)

### Landing Page Redesign (FOUNDATION)
- **Priority:** 🔴 P1 — unblock all other initiatives
- **Timeline:** 3 weeks (complete by Aug 1, 2026)
- **Owner:** Michael (copy) + Hugo (build)
- [ ] Audit current homepage UX vs. target state with Ben
- [ ] Draft copy deck: headline, CTAs, pillar descriptions (Michael)
- [ ] Design mockup: 3-pillar layout, featured posts section (Michael)
- [ ] Build Hugo changes: update index page, add CSS, ensure responsive (Hugo)
- [ ] Deploy A/B test: track RSS conversion rate vs. baseline
- **Why:** New visitors don't understand Ben's positioning; discovery funnel breaks at homepage
- **Success:** RSS CTR increases 40%+ vs. July baseline

### Leadership Essentials Series (REAL PILLAR)
- **Priority:** 🔴 P1 — positions Ben as thought leader on technical leadership
- **Timeline:** 4 months, 1 post/month (Aug, Sept, Oct, Nov)
- **Owner:** Quill (structure) + Meta (frameworks) + Simon (DEI review)
- **Cadence:** Blog (2500+ words) → LinkedIn article (1) → LinkedIn extracts (3-4 per post, spread weekly)
- Posts:
  - [ ] **#1 Aug 15:** "How to Lead Without Authority — And Still Get Things Done" (real: influence, matrix navigation, advisory boards)
  - [ ] **#2 Sept 19:** "The Feasibility Discipline Framework" (strategy: AI evaluation, risk taxonomy, saying no)
  - [ ] **#3 Oct 17:** "Career Decisions That Compound" (real: specialization, pinnacle patterns, visibility)
  - [ ] **#4 Nov 7:** "Coaching Through Ambiguity" (real: psychological safety, shipping in uncertainty)
- **Dependencies:** Interviews with 2 practitioners per post (identify by July 30)
- **Why:** Unique voice on leadership from CTO Office vantage; addresses aspiring leader audience gap
- **Success:** Leadership series posts avg 1800+ words, 4-5 min LinkedIn article time, 6+ LinkedIn posts per core post

### Your Career × Your Product Series (REAL + STRATEGY)
- **Priority:** 🟡 P2 — explores career compounding through product impact
- **Timeline:** 8 weeks, 1 post every 2 weeks (Aug 22, Sept 26, Oct 24)
- **Owner:** Simon (narrative, interview coordination) + Quill (structure)
- **Format:** Documentary narrative + LinkedIn extracts
- Posts:
  - [ ] **#1 Aug 22:** "The Platform Engineer's Dilemma: Individual Achievement vs. Team Impact" (interview 1 IC)
  - [ ] **#2 Sept 26:** "Building in Public While Scaling Private" (interview 1 creator-engineer hybrid)
  - [ ] **#3 Oct 24:** "The Specialist's Edge — Why Deep Expertise Creates Career Optionality" (interview 1 vertical expert)
- **Dependencies:** Identify 3 interview subjects by Aug 1; coordinate interview logistics
- **Why:** Addresses career development audience; shows how product impact drives career velocity
- **Success:** Practitioner interviews feel authentic, 800+ words per feature, Simon's DEI review flags zero concerns

### WaveMaker Model — Technical Leadership Framework (STRATEGY PILLAR)
- **Priority:** 🟡 P2 — launches new signature framework
- **Timeline:** 6 weeks (Sept 12 publish)
- **Owner:** Meta (framework architecture) + Simon (examples validation) + Hugo (repo)
- **Deliverables:**
  - [ ] Blog post: 3000+ words, WaveMaker framework deep-dive (Meta)
  - [ ] LinkedIn article republish (Meta)
  - [ ] 4x LinkedIn short-form posts (1 per role: Initiators, Connectors, Builders, Amplifiers) (Meta)
  - [ ] GitHub cheatsheet: "WaveMaker Self-Assessment" PDF + interactive YAML decision tree (Hugo)
- **Framework Elements:**
  - Initiators (see gap, raise flag first)
  - Connectors (build coalitions, stakeholder buy-in)
  - Builders (prototype, prove feasibility)
  - Amplifiers (scale, share patterns)
- **Dependencies:** Ben validates framework definitions by Aug 15
- **Why:** Turns internal mental model into repeatable framework; customer advisory boards will reference this
- **Success:** Framework is 100% internally coherent; Ben uses "WaveMaker" language in 3+ customer calls by Dec

### Copilot Studio Best Practices Series (BUILD PILLAR)
- **Priority:** 🔴 P1 — addresses market gap, differentiates from surface-level content
- **Timeline:** 12 weeks, 1 post every 2 weeks (Aug 29, Oct 10, Oct 31, Nov 21)
- **Owner:** Hugo (technical depth) + Michael (customer patterns)
- **Format:** Deep technical blog (2500-3500 words) → GitHub reference architecture → LinkedIn hot take series
- Posts:
  - [ ] **#1 Aug 29:** "Designing Enterprise Copilot Studio Agents — Architecture Patterns That Scale" (system prompts, RAG, governance hooks)
  - [ ] **#2 Oct 10:** "The Analytics Gap in Copilot Studio — Measuring Agent Success Beyond Click Counts" (telemetry, attribution, failure taxonomy)
  - [ ] **#3 Oct 31:** "Securing Copilot Studio Deployments" (RBAC, Entra integration, audit trails, compliance)
  - [ ] **#4 Nov 21:** "Moving to Production — Testing, Rollout, and Incident Triage Patterns" (canary releases, monitoring, SRE practices)
- **GitHub Repo Deliverables:**
  - [ ] Reference architecture YAML for each post (4 total)
  - [ ] Runnable Copilot Studio agent templates
  - [ ] PowerShell automation tooling for deployment
  - [ ] Analytics dashboard starter
- **Dependencies:** Customer example audit by July 31; coordinate with Copilot Studio field for wins
- **Why:** Enterprise customers adopting rapidly; content gap is real; GitHub repo becomes trusted reference
- **Success:** Repo reaches 100+ stars by Dec; blog posts avg 3000+ words, 7+ min reads; field asks Ben for "that blog post" in customer calls

## 🟢 Future / Nice-to-Have

### Framework Fridays Series
- **Framework Fridays** — 1 cheatsheet/framework per month (strategy pillar)
- Candidates: MLOps Misconception, Data Mesh Paradox, FinOps for AI
- **Timeline:** Launch Q1 2027 after H2 core initiatives prove sustainable

### From the Field Series
- **From the Field** — Customer engagement reflections, anonymised (real pillar)
- **The Outage Report** — Deep-dive on Azure challenges with tooling (build pillar)
- **Boardroom Briefing** — C-level topic for execs and engineers (strategy pillar)

### Newsletter / Email List
- Evaluate: Buttondown, Substack, or simple Mailchimp integration
- Embed subscribe form in blog footer post-landing-page redesign

### Cross-post Strategy
- Republish Copilot Studio series to Dev.to, Medium, Hashnode for reach
- Always canonical-link back to benmartinbaur.github.io