# Squad Decisions

## Active Decisions

### 1. H2 2026 Content Program — Five Initiatives

**Date:** 2026-07-18  
**Owner:** Toto (Chief of Staff)  
**Status:** DECIDED  
**Impact:** Strategic direction for all five initiatives; Toto reviews all content for brand alignment

**Decision:** Execute five parallel content initiatives with strict pillar discipline and 30/60/90 execution plan:
1. Landing Page Redesign (Real + Strategy) — Michael + Hugo
2. Leadership Essentials Series (Real + Strategy) — Quill + Meta
3. Career × Product Series (Real) — Simon + Quill  
4. WaveMaker Model Framework (Strategy) — Meta + Simon
5. Copilot Studio Best Practices (Build) — Hugo + Michael

**Key Constraints:**
- 12 new blog posts (2x/month cadence)
- 180+ LinkedIn posts (3-6x/week)
- Quality gates mandatory: Exactly ONE pillar per post, approved tags only, featured image required, Simon DEI review
- Timeline: Phase 0 (Weeks 1-4), Phase 1 (Aug-Sept), Phase 2-4 (Sept-Dec)

**Success Criteria:**
- Blog visitors: 1,200 → 2,500+
- RSS subscribers: 45 → 120+
- LinkedIn followers: 8,100 → 9,500+
- LinkedIn engagement: 2-3% → 4-5%

---

### 2. Landing Page Rebuild Strategy

**Date:** 2026-07-18  
**Owner:** Hugo (Frontend Developer)  
**Status:** DECIDED  
**Impact:** Homepage UX, content discoverability, conversion pathways

**Decision:** Three-phase homepage redesign:
- **Phase 1 (MVP):** Hero section, pillar cards (3 most recent per pillar), featured post, email CTA, dark mode support
- **Phase 2 (Depth):** Section pages (/build/, /strategy/, /real/) with pillar-specific heroes, auto-populating post lists
- **Phase 3 (Advanced):** Featured image API, related posts widget, reading time per section, newsletter archive

**Key Technical Decisions:**
- Work within existing Stack theme sidebar (no major refactoring)
- Remove homepage widgets (search, archives, tag-cloud → dedicated pages)
- Three pillar section pages via Hugo sections (_index.md)
- Featured post auto-selects latest across all categories
- Single email CTA (Mailchimp) + social links only

**Timeline:**
- Phase 1: 1-2 weeks
- Phase 2: 2-3 weeks post-Phase 1
- Phase 3: TBD (optional)

---

### 3. Leadership Series Architecture & Brand Tone

**Date:** 2026-07-18  
**Owner:** Michael (Leadership & Mindset Coach)  
**Status:** DECIDED  
**Impact:** Eight-post Real pillar content; shapes audience engagement model

**Decision:** Approve "Leading from the Front Lines" 8-post series (1,200–1,600 words each) over 16 weeks with mixed distribution and three critical guardrails:

**Series Structure:** Foundation → Execution → Perspective  
**Distribution:** Blog posts + LinkedIn articles + short-form posts + downloadable templates

**Critical Guardrail — "Coffee Test":**
Every post must pass: Would Ben explain this idea to a colleague over coffee as conversational reflection, or as a lecture? If lecture, reframe.

**Four Risk Mitigations:**
1. **Preachy Tone:** Lead every post with failure story; use "Here's what I learned" not "You should"
2. **False Universality:** Acknowledge frame ("As a technical architect in a big org..."); feature diverse perspectives
3. **Abstraction Without Teeth:** Every post includes 1 failure story, 1 framework, 1 checklist, 1 template
4. **Build Pillar Alienation:** Use systems language; connect to technical outcomes

**Success Metrics:**
- Short-term (Week 8): 20K+ impressions, 100+ downloads, 25+ comments
- Long-term (Week 16): 50K+ impressions, 300+ downloads, 100+ implementation stories, +25% subscriber growth

---

### 4. Career Development Series Architecture

**Date:** 2026-07-18  
**Owner:** Alex (Sr. HR & Talent Sourcer)  
**Status:** DECIDED  
**Impact:** Dual-track Real pillar series; flexible audience self-selection

**Decision:** Implement dual-series + competency ladder architecture:

**Series 1 (Posts 1-4, Jul-Aug):** "Your Career × Your Product"
- Narrative stories about career building through shipping, influence, relationships, executive transition
- Accessible to early-career engineers; sets engagement foundation

**Series 2 (Posts 5-8, Sep-Oct):** "WaveMaker"
- Public framework for technical leadership competencies: Impact, Influence, Innovation, Integrity, Insight
- Provides conceptual scaffolding validating/explaining Series 1 stories

**Flexible Entry Points:**
- Early-career: Series 1 → Series 2 (foundational)
- Mid-level: Series 2 → Series 1 (competency + application)
- Senior: Series 2 only (advanced)

**Publishing Order Rationale:** Narrative-first (Jul-Aug) drives engagement; framework-second (Sep-Oct) provides understanding

**Success Criteria:**
- 1,200–1,800 avg reads per post (+25% above blog baseline)
- 30–50 substantive comments across series
- 3–5 min average time-on-page
- 2–4 new professional opportunities generated

---

### 5. Copilot Studio Best Practices Series Architecture

**Date:** 2026-07-18  
**Owner:** John (Technical Architect)  
**Status:** DECIDED  
**Impact:** Production-grade Build pillar content; enterprise thought leadership

**Decision:** Produce 6-8 post series on Copilot Studio best practices (Plan → Build → Operate) by 2026-10-31:

**Series Structure:**
| Post | Topic | Audience | Focus |
|------|-------|----------|-------|
| 1 | Foundation: PoC to Production Design | Architects, CTOs | Upfront design thinking |
| 2 | Knowledge Architecture: RAG & Governance | Data Owners, Solutions Architects | Knowledge source strategy |
| 3 | Security & Authentication | Security Architects, Compliance | Identity and access |
| 4 | Integration Patterns | Integration Engineers | System connectivity |
| 5 | Observability & Evaluation | PMs, DevOps | Quality metrics, monitoring |
| 6 | Governance & Lifecycle | Enterprise Architects, Program Managers | Operations, scaling |
| 7 | Cost & Performance Optimization | Finance, Product Managers | Economics, efficiency |
| 8 (Optional) | Advanced Topics: Edge Cases | Principal Architects | Production hardening |

**Mandatory Sections Per Post:**
- Security (Auth, data classification, compliance, misconfigurations)
- Governance (Policy decisions, ownership, approval workflows, audit)
- Observability (Metrics, dashboards, alerting, cost tracking)
- Evaluation (Testing, validation, pre-production steps)

**Anti-Patterns Strategy:** Every post cites 3-5 anonymized customer failure scenarios; more credible than theoretical best practices

**Visual Deliverables:** 8 whiteboard-ready SVG diagram types across series

**Success Criteria:**
- All 6-8 posts published by 2026-10-31
- John technical review on every post
- ≥1 anonymized customer scenario per post
- LinkedIn reshare rate >2x typical posts
- Enterprise team references series in guidance requests

---

### 6. Series Structures Blueprint Approach

**Date:** 2026-07-18  
**Owner:** Quill (Technical Writer)  
**Status:** DECIDED  
**Impact:** Editorial system design; content reuse and discoverability

**Decision:** Consolidate from four original series to three unified series with distinct voice guardrails:

**Three Primary Series:**
1. **Leadership Labs** (Real, 1x/month)
   - Audience: Tech leaders, executives, managers at scale
   - Voice: Mentor-like, pattern-focused, leads from observation

2. **Career Compass** (Real, 1x/month)
   - Audience: Mid-career technologists, aspiring architects
   - Voice: Personal, vulnerable, inclusive of different paths

3. **Copilot Studio Playbooks** (Build + Strategy, 2x/month alternating)
   - Audience: Solution architects, app developers, practitioners
   - Voice: Direct, technical, failure-mode conscious

**What We Dropped:**
- Framework Fridays (merged into Copilot Studio Strategy track)
- Boardroom Briefing (absorbed into Leadership Labs)
- The Outage Report (one-off Build posts instead)
- From the Field (model too similar to existing Real pillar)

**Editorial Innovations:**
- Reusable post skeletons per series (40% faster iteration)
- Internal linking strategy (1-2 links per post to same series)
- Cross-series bridges (1-2 links to contextually relevant posts in other series)
- Hub posts consolidating related frameworks

**Cadence:** 4 posts/month total (Leadership Labs 1x, Career Compass 1x, Copilot Playbooks 2x)

**Success Criteria:**
- Three series anchor "Start Here" posts (Month 1)
- First deep post per series (Month 1)
- Internal linking structure tested (Month 2)
- Editorial cadence sustained 2+ months (Month 2-3)
- Cross-series link engagement observed in analytics

---

## Governance

- All meaningful changes require team consensus
- Document architectural decisions here
- Keep history focused on work, decisions focused on direction
- Every decision includes: Context, Decision, Rationale, Success Criteria, Next Steps
- Toto maintains weekly cadence reviews; Ben approves strategic decisions
