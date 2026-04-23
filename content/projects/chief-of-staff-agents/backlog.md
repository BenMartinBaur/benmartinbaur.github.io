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

## 🟢 Future / Nice-to-Have

### Launch content series
- **Framework Fridays** — 1 cheatsheet/framework per month (strategy pillar)
- **From the Field** — Customer engagement reflections, anonymised (real pillar)
- **The Outage Report** — Deep-dive on Azure challenges with tooling (build pillar)
- **Boardroom Briefing** — C-level topic for execs and engineers (strategy pillar)

### Visual identity system
- Logo: stylised "A" combining architecture blueprint + neural network motif
- Colour palette enforced: `#1E2761` (navy), `#F96167` (coral), `#F5F5F5` (off-white)
- Font pairing: Inter or DM Sans for headings, Inter for body

### Newsletter / email list
- Evaluate options: Buttondown, Substack cross-post, or simple Mailchimp
- Embed subscribe form in blog footer

### Cross-post strategy
- Republish selected posts to dev.to, Medium, or Hashnode for reach
- Always canonical-link back to benmartinbaur.github.io