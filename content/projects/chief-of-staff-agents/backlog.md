# Chief of Staff Agents — Backlog

Items the AI Chief of Staff team will execute, ordered by priority.

---

## 🔴 High Priority

### Add CTA to every post
- Add LinkedIn follow link + RSS subscribe to the footer of every post
- Consider a Hugo partial template for consistent CTA block
- **Why:** No engagement loop exists — readers leave with no way to follow

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

---

## 🟡 Standard Priority

### Create branded featured image template
- Design consistent template: dark navy gradient + coral accent line + white title text
- Apply to all existing and future posts
- **Why:** Posts currently have inconsistent visual identity in feeds

### Add tagline to blog header
- Add "Where Strategy Meets the Stack" as subtitle in hugo.toml
- Update `[params.sidebar]` subtitle from "Thoughts and ideas by Ben" to tagline
- **Why:** Differentiates "The Architect" from hundreds of generic blogs

### Write anchor post
- Title: "What This Blog Is About & Who It's For"
- Pin to homepage or link prominently
- Covers: who Ben is, the three content pillars, what readers can expect
- **Why:** New visitors need orientation; About page is too buried

### Fix "Business Envisioning Cheatsheet" post
- `content/posts/2026-04-01-business-envisioning-cheatsheet/index.md` has no front-matter
- Add proper YAML front-matter (title, date, category: strategy, tags)
- **Why:** Post won't render correctly in Hugo without front-matter

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