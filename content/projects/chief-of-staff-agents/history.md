# Chief of Staff Agents — Change History

All changes made by the AI Chief of Staff team to the blog, documented in reverse chronological order.

---

## 2026-03-18 — Brand Name & Visual Identity

### Brand Name Changed
- **Old:** "The Architect | Ben Baur"
- **New:** "B3N.B4UR_"
- File: `hugo.toml` line 3 (`title`)
- Leet speak treatment: numbers 3 & 4 displayed in Coral Energy (#F96167) accent colour
- Logo font: Space Grotesk Bold
- Favicon: BB (Ben Baur)

### Tagline Updated
- **Old:** "Thoughts and ideas by Ben"
- **New:** "From the server room to the boardroom"
- File: `hugo.toml` line 20

### Colour Scheme Approved
| Element | Value | Notes |
|---------|-------|-------|
| Primary | `#34495e` (Slate) | Keep existing — no change |
| Accent | `#F96167` (Coral Energy) | Blockquotes, hovers, highlights |
| Dark mode accent | `#7B8CDE` (Soft Lavender) | Links, tags in dark mode |

### Featured Image System Approved
Three distinct visual styles per content pillar:
- 🏗️ **Build** — Dark blue/gray terminal gradient
- 🗺️ **Strategy** — Coral→purple gradient (existing BXT style)
- 🎤 **Real** — Light blue/lavender watercolour (existing Vegan style)

---

## 2026-03-18 — Initial Audit & Restructure

### Blog Post Created
- **New post:** `content/posts/2026-03-18-ai-chief-of-staff/index.md` — "How AI Became My Personal Chief of Staff Team"
- Category: `real` | Tags: AI, Strategy, Leadership

### Bugs Fixed
| File | Issue | Fix |
|------|-------|-----|
| `content/posts/2026-03-01-30days/index.md` | Raw Hugo markdown leaking (`content/gallery/my-first-gallery/index.md` visible to readers) | Replaced broken syntax with proper image gallery |
| `content/posts/2026-03-20-vegan-my-story/index.md` | "plat-based" (2x), "A t the same", "we though" | → "plant-based", "At the same", "we thought" |
| `content/about/index.md` | "adn defining" | → "and defining" |

### Categories Restructured
Old categories (`social`, `ai`, `cloud`) replaced with content-pillar categories:

| Post | Old Category | New Category |
|------|-------------|--------------|
| First 30 Days (photo) | social | **real** |
| First 30 Days (customer conversations) | social | **real** |
| BXT Framework Cheatsheet | ai | **strategy** |
| Frontier CoE meets Cloud CoE | ai | **strategy** |
| CAF vs AI Adoption Framework | ai | **strategy** |
| Azure Default Outbound Access | cloud | **build** |
| Welcome to the Boardroom | social | **strategy** |
| Let's Get Real Cheatsheet | social | **strategy** |
| Vegan — My Story | social | **real** |
| Intune & W365 Naming | cloud | **build** |
| AI Chief of Staff (new) | — | **real** |

### Tags Pruned
Reduced from 27 tags to 15. Removed: LinkedIn, Social Media, NAT Gateway, Cloud PC, Naming Convention, Microsoft Graph, Endpoint Management, Business Strategy, Reference, Cloud, Customer Engagement, Hugo, Markdown, Shortcodes, Projects, Data Science, Machine Learning, Research.

| Post | Old Tags | New Tags |
|------|----------|----------|
| First 30 Days (photo) | AI, LinkedIn, Social Media, Leadership | AI, Leadership |
| First 30 Days (conversations) | AI, LinkedIn, Social Media, Leadership | AI, Leadership, Strategy |
| BXT Cheatsheet | AI, Strategy, Leadership, Framework, Customer Engagement | AI, Strategy, Framework, Consulting |
| Frontier CoE | AI, Cloud, Leadership, Strategy, Center of Excellence | AI, Strategy, Center of Excellence, Leadership |
| CAF vs AI | AI, Strategy, Best Practices, Business Strategy, Framework, Reference | AI, Strategy, Framework, Best Practices |
| Azure Outbound | Azure, AVD, W365, Networking, NAT Gateway, PowerShell, Security, Best Practices | Azure, AVD, W365, Networking, PowerShell, Security, Best Practices |
| Boardroom | AI, LinkedIn, Social Media, Leadership | AI, Strategy, Leadership |
| Let's Get Real | AI, LinkedIn, Social Media, Leadership | Strategy, Framework, Consulting |
| Vegan | LinkedIn, Social Media, Leadership | Leadership |
| Intune Naming | Intune, W365, Cloud PC, Naming Convention, Best Practices, Microsoft Graph, Automation, Endpoint Management | Windows 365, Intune, Best Practices, Automation |