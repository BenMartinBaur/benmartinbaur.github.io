# Chief of Staff Agents — Landing Page Rebuild Plan

**Document Owner:** Hugo (Frontend Developer)  
**Project:** B3N.B4UR_ / Chief of Staff Agents  
**Date Created:** 2026-07-18  
**Status:** Planning Phase  

---

## Executive Summary

The B3N.B4UR_ homepage currently serves as a blog index within Stack theme defaults. This plan proposes a strategic rebuild that positions the site as a **portal to three distinct content experiences** (Build, Strategy, Real) while maintaining the proven Stack theme architecture and existing customizations.

The rebuild achieves:
- **Clear information architecture** that disambiguates content pillars for first-time visitors
- **Conversion-focused CTAs** tailored to different audience segments (CTOs, architects, engineers, leaders)
- **Reusable Hugo partials** that scale the approach to project landing pages and section indexes
- **Phased rollout** (MVP launch in Phase 1, depth in Phase 2) to avoid disrupting current publishing cadence

---

## Section 1: Current-State Gap Analysis

### Existing Strengths
- **Stack theme foundation** is solid — sidebar navigation, dark mode, article cards, and tagging all work well
- **Brand assets in place** — Coral/Lavender accents, Space Grotesk, featured image system all defined in `brandstrategy.md`
- **SCSS overrides proven** — Custom dark-mode links, blockquote styling, and card treatments already implemented in `assets/scss/common/_custom.scss`
- **Hugo scaffolding mature** — SEO metadata, canonical URLs, reading time all configured

### Identified Gaps

| Gap | Impact | Why It Matters |
|-----|--------|---|
| **No pillar signposting** | Visitors land on blog index; don't know if this is strategy, technical, or personal | First impression matters; architecture readers need different value props than engineering readers |
| **No audience CTAs** | Content is scattered; no conversion pathway (newsletter, GitHub follow, LinkedIn follow, internal contact) | Current backlog item: "Add CTA to every post" — but homepage needs a parent CTA first |
| **Homepage is widget-heavy** | Search, archives, tag-cloud widgets occupy precious above-the-fold space | Stack's default homepage layout wastes opportunity to explain brand positioning |
| **No "what this is for" statement** | About page is excellent, but homepage doesn't funnel readers there | Visitors bounce because they don't understand the thesis in <3 seconds |
| **Project pages lack consistent IA** | Chief of Staff Agents has 5 files; no clear indexing or navigation between them | Scales poorly when more projects are added (Cosio, future ones) |
| **No section/hub pages** | Posts are discoverable only via archive or tag cloud | Would benefit from "All Build Posts," "All Strategy Posts," "All Real Posts" with author commentary |

---

## Section 2: Proposed Homepage Architecture

### Information Hierarchy

```
HOMEPAGE (/)
├─ Hero Section
│  ├─ Brand name + tagline
│  ├─ One-liner positioning
│  └─ [Scroll cue]
├─ Three Pillar Cards (linked to /build/, /strategy/, /real/)
│  ├─ Icon + category name + description
│  ├─ 2–3 most recent posts in pillar
│  └─ "Explore all" CTA
├─ Latest Post (full hero + excerpt, featured image)
├─ Newsletter/Contact CTA Section
└─ Footer (social links, legal)
```

### Page Sections (Detailed)

#### 1. Hero Section
**Objective:** Brand clarity + positioning in <3 seconds  
**Height:** 100vh (full viewport on desktop, 70vh mobile)  
**Layout:** Centered text OR left-aligned text with abstract background graphic

**Content:**
```
B3N.B4UR_
━━━━━━━━━━
From the server room to the boardroom

[Subtitle] Technical Architect @ Microsoft CTO Office
[Body] I help enterprises turn AI strategy into systems that ship.
       This site documents what I've learned bridging boardroom + terminal.

[CTA: Explore Posts] [CTA: About Me]
```

**Visual Treatment:**
- Primary colour (#34495e) background with subtle gradient
- Brand name in Space Grotesk Bold
- Numbers 3 & 4 in Coral (#F96167)
- Underscore animates like a blinking terminal cursor

---

#### 2. Three Pillar Cards Section
**Objective:** Disambiguation + funnel to pillar-specific indexes  
**Height:** 3–4 rows (grid layout, responsive)  
**Layout:** CSS Grid (3 cols on desktop, 1 col mobile, 2 cols tablet)

**Card Structure (per pillar):**
```
┌─────────────────────────┐
│ [Pillar Icon]           │
│ Pillar Name             │
│ One-line description    │
├─────────────────────────┤
│ [Recent Post 1]         │
│ • Title, date           │
│ ───────────────────────│
│ [Recent Post 2]         │
│ • Title, date           │
│ ───────────────────────│
│ [Recent Post 3]         │
│ • Title, date           │
└─────────────────────────┘
[→ View all 23 posts]
```

**Per-Pillar Specs:**

| Pillar | Icon | Description | Link |
|--------|------|---|---|
| 🏗️ **Build** | `[code icon]` | Hands-on architecture, tooling, scripts. For engineers shipping real systems. | `/build/` |
| 🗺️ **Strategy** | `[map icon]` | Frameworks, decision models, thinking for CTOs and architects. | `/strategy/` |
| 🎤 **Real** | `[speech icon]` | Leadership, career, honest reflections from 15+ years in the field. | `/real/` |

**Card Styling:**
- Pillar-specific accent colour (Coral for Strategy, Lavender for Real, keep Slate for Build)
- Featured image from most recent post in pillar (if available)
- Hover effect: Subtle lift + accent underline
- Post list truncated to 3; "View all" link includes post count

---

#### 3. Featured Post Section
**Objective:** Spotlight latest + drive engagement  
**Height:** 40vh (desktop), 50vh (mobile)  
**Layout:** Left-text, right-image OR full-width hero

**Content:**
```
[Pillar Tag]
[Post Title]
[Author + Date + Read Time]
[Excerpt (2–3 lines)]
[→ Read Full Post] [→ Share on LinkedIn]
```

**Visual Treatment:**
- Featured image from post (1200×630px, pillar-specific gradient)
- Post title overlaid in white if image is background
- Author avatar (Ben's photo) + byline below title

---

#### 4. Newsletter / Contact CTA Section
**Objective:** Capture emails + offer direct pathways  
**Height:** 20vh  
**Layout:** Centered, two-column buttons or stacked email signup

**Content:**
```
Stay connected.

□ Get new posts via email
[Email input] [Subscribe]

or

[LinkedIn: Follow for hot takes]
[GitHub: View scripts & tools]
[Calendar: Book a conversation]
```

**Visual Treatment:**
- Coral background (or dark with coral accents)
- White text, high contrast
- Buttons clearly differentiated (primary = email, secondary = social)

---

#### 5. Footer
**Content:** Copyright, social links, legal, sitemap  
**Styling:** Match existing Stack theme footer

---

## Section 3: Reusable Block/Partial Strategy for Hugo Stack Theme

### New Partials to Create

#### 1. `layouts/_partials/hero.html`
**Purpose:** Flexible hero section with brand positioning  
**Parameters:**
- `title` (string) — main headline
- `subtitle` (string) — secondary copy
- `cta_primary` (object) — `{text, link}`
- `cta_secondary` (object) — optional
- `background` (string) — "gradient" | "image" | "none"
- `height` (string) — "full" | "medium" | "short"

**Usage:**
```html
{{ partial "hero" (dict "title" "B3N.B4UR_" "subtitle" "From server room to boardroom" ...) }}
```

**Features:**
- Space Grotesk Bold rendering for `title`
- Coral accent for brand numbers (via regex replace in title)
- Terminal cursor blink animation on underscore
- Responsive height (100vh → 70vh on mobile)

---

#### 2. `layouts/_partials/pillar-cards.html`
**Purpose:** Reusable three-column grid for pillar indexes  
**Parameters:**
- `pillars` (array) — list of pillar objects: `{name, icon, description, posts, url}`
- `mode` (string) — "homepage" (full cards) | "index" (compact)

**Usage:**
```html
{{ partial "pillar-cards" (dict "pillars" .Site.Params.contentPillars "mode" "homepage") }}
```

**Features:**
- CSS Grid auto-layout (3 cols → 1 col responsive)
- Pillar-specific accent colours from `_variables-custom.scss`
- Post list truncation + "View all X posts" dynamic link
- Hover states with accent underline

---

#### 3. `layouts/_partials/featured-post.html`
**Purpose:** Spotlight single post with featured image + metadata  
**Parameters:**
- `post` (object) — page object or post object
- `show_image` (bool) — whether to display featured image
- `mode` (string) — "hero" (large) | "compact" (card)

**Usage:**
```html
{{ partial "featured-post" (dict "post" .Site.RegularPages.First "show_image" true) }}
```

**Features:**
- Featured image (1200×630) with pillar-specific gradient
- Post title, excerpt, author, date, read time
- Dual CTAs: "Read Full Post" + "Share on LinkedIn"
- Overlay logic for dark backgrounds

---

#### 4. `layouts/_partials/cta-section.html`
**Purpose:** Email signup + social link section  
**Parameters:**
- `heading` (string)
- `email_enabled` (bool)
- `social_links` (array) — `{name, url, icon}`
- `background` (string) — colour or none

**Usage:**
```html
{{ partial "cta-section" (dict "heading" "Stay connected" "email_enabled" true ...) }}
```

**Features:**
- Email form integration (Mailchimp or similar)
- Dynamic social link icons from Tabler Icons library
- Responsive button layout (side-by-side desktop, stacked mobile)

---

### New Shortcodes to Create

#### 1. `{{< pillar-list >}}`
**Purpose:** Embed all posts from one pillar on a section page  
**Parameters:**
- `category` — "build" | "strategy" | "real"
- `limit` — default 10
- `show_excerpt` — true/false

**Usage:**
```markdown
{{< pillar-list category="build" limit=10 show_excerpt=true >}}
```

**Output:** Sorted post list with featured images, excerpts, metadata

---

#### 2. `{{< cta-button >}}`
**Purpose:** Consistent button styling per pillar  
**Parameters:**
- `text` — button label
- `url` — link target
- `style` — "primary" | "secondary" | "accent"

**Usage:**
```markdown
{{< cta-button text="View all Strategy posts" url="/strategy/" style="primary" >}}
```

---

### CSS Architecture (SCSS)

**File:** `assets/scss/common/_custom.scss` (existing, extend)

**New classes to add:**
```scss
// Hero section
.hero {
  height: 100vh; // full height on desktop
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-primary-subtle-gradient);
}

.hero-title {
  font-family: "Space Grotesk", sans-serif;
  font-weight: bold;
  font-size: 4rem; // responsive
  
  // Brand treatment: highlight numbers 3 & 4
  .coral { color: var(--color-accent-coral); }
}

.hero-cursor {
  animation: blink 1s infinite;
}

// Pillar cards
.pillar-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 2rem;
}

.pillar-card {
  padding: 2rem;
  border-radius: 8px;
  background: var(--color-card-bg);
  border-left: 4px solid var(--color-accent-primary);
  transition: transform 0.2s, box-shadow 0.2s;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  }
}

// Featured post
.featured-post {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  
  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}

.featured-post-image {
  position: relative;
  overflow: hidden;
  border-radius: 8px;
  aspect-ratio: 4/3;
  background: linear-gradient(135deg, var(--color-accent-coral), var(--color-accent-lavender));
  
  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

// CTA section
.cta-section {
  padding: 4rem 2rem;
  background: var(--color-accent-coral);
  color: white;
  text-align: center;
  
  button {
    margin: 0.5rem;
    padding: 1rem 2rem;
    border: none;
    border-radius: 4px;
    font-weight: bold;
    cursor: pointer;
    transition: opacity 0.2s;
    
    &:hover {
      opacity: 0.9;
    }
  }
}

// Dark mode overrides
:root[data-theme="dark"] {
  --color-accent-coral: #F96167;
  --color-accent-lavender: #7B8CDE;
  
  .pillar-card {
    border-left-color: var(--color-accent-lavender);
  }
}
```

**Design Tokens (extend `_variables-custom.scss`):**
```scss
// Typography
$font-family-display: "Space Grotesk", sans-serif;
$font-size-hero: clamp(2rem, 8vw, 4rem);

// Colors (pillar-specific)
$color-pillar-build: #0C1824;
$color-pillar-strategy: #F96167;
$color-pillar-real: #89B4E8;
$color-accent-coral: #F96167;
$color-accent-lavender: #7B8CDE;

// Spacing
$spacing-hero: 100vh;
$spacing-cards: 2rem;
```

---

## Section 4: Content Requirements per Section

### Hero Section
**Length:** 30–50 words  
**Tone:** Direct, authoritative, welcoming  
**Elements needed:**
- [ ] Brand name with leet-speak treatment
- [ ] Tagline (existing: "From the server room to the boardroom")
- [ ] 1–2 sentence positioning statement
- [ ] CTA buttons (suggested: "Explore Posts" + "About Me")

**Current copy to use (from `brandstrategy.md`):**
```
B3N.B4UR_
Technical Architect @ Microsoft CTO Office · 
I help enterprises turn AI strategy into systems that ship.
```

---

### Pillar Cards Section
**Per-card copy requirements:**

**Build Card:**
- [ ] Category name: "🏗️ Build"
- [ ] Description: "Hands-on architecture, tooling, and scripts for engineers shipping real systems"
- [ ] Recent posts (auto-populate from site data)
- [ ] CTA: "View all BUILD posts (N posts)"

**Strategy Card:**
- [ ] Category name: "🗺️ Strategy"
- [ ] Description: "Frameworks, decision models, and thinking for CTOs and architects"
- [ ] Recent posts (auto-populate from site data)
- [ ] CTA: "View all STRATEGY posts (N posts)"

**Real Card:**
- [ ] Category name: "🎤 Real"
- [ ] Description: "Leadership lessons, career stories, and honest reflections from 15+ years"
- [ ] Recent posts (auto-populate from site data)
- [ ] CTA: "View all REAL posts (N posts)"

---

### Featured Post Section
**Auto-populated:** Latest post across all categories  
**Static copy:**
- [ ] Byline: "Latest from B3N.B4UR_"
- [ ] CTA 1: "Read full post"
- [ ] CTA 2: "Share on LinkedIn"

---

### CTA Section
**Copy:**
```
Stay connected.

Get new posts delivered to your inbox.
[Email] [Subscribe]

Or follow for hot takes and patterns:
[LinkedIn] [GitHub]
```

**Integration points:**
- [ ] Email signup → Mailchimp or alternative
- [ ] LinkedIn URL → `hugo.toml` social menu
- [ ] GitHub URL → `hugo.toml` social menu

---

## Section 5: Visual & Content Style Guidance

### Brand System (Reference)

**Typography:**
- Display: Space Grotesk Bold (brand name, section headings)
- Body: Lato (existing, unchanged)
- Monospace: Fira Code (code blocks, existing)

**Colour Palette:**
| Element | Light | Dark | Notes |
|---------|-------|------|-------|
| Primary | `#34495e` (Slate) | `#34495e` | Unchanged from Stack theme |
| Accent | `#F96167` (Coral) | `#7B8CDE` (Lavender) | Blockquotes, hovers, CTAs |
| Background | `#f5f5fa` | `#0a0e27` (dark default) | Subtle, readable |
| Text | `#2c3e50` | `#e5e5e5` | High contrast |

**Spacing & Sizing:**
- Base unit: `8px`
- Section padding: `4rem` (desktop), `2rem` (mobile)
- Card gap: `2rem`
- Hero height: `100vh` (desktop), `70vh` (mobile)

**Imagery:**
- Featured images: 1200×630px (featured post section)
- Pillar cards: optional featured image from most recent post (scaled to 320×180px)
- Background graphics: subtle gradients, no photography unless needed

**Interactions:**
- Hover states: Subtle lift (`transform: translateY(-4px)`) + accent underline
- Focus states: Clear outline for accessibility
- Link underlines: Thin, accent colour (Coral light mode, Lavender dark mode)
- Animations: Subtle only (cursor blink, hover lift) — avoid auto-playing

---

### Accessibility Requirements

- [ ] **ARIA labels** on all icons
- [ ] **Alt text** on all images (pillar icons, featured images)
- [ ] **Heading hierarchy:** H1 (hero title) → H2 (section headings) → H3 (post titles in cards)
- [ ] **Colour contrast:** WCAG AA minimum (7:1 for text, 4.5:1 for interactive elements)
- [ ] **Keyboard navigation:** All CTAs accessible via Tab
- [ ] **Skip link:** At top of page for screen reader users
- [ ] **Reduced motion:** Respect `prefers-reduced-motion` media query (disable animations)

---

### Mobile Optimization

**Viewport breakpoints:**
- Mobile: `<480px` — single column, stacked cards, reduced hero height
- Tablet: `480px–768px` — two-column grid for pillar cards
- Desktop: `>768px` — full three-column grid, side-by-side featured post

**Touch optimization:**
- Button min size: 44×44px
- Tap target spacing: `0.5rem` min
- No hover-required interactions (all info accessible on tap)

---

## Section 6: Phased Implementation Plan

### Phase 1: MVP Homepage (1–2 weeks)

**Objective:** Establish pillar signposting and basic conversion pathways

**Deliverables:**
1. [ ] Hero section partial (`_hero.html`) with brand positioning
2. [ ] Pillar cards partial (`_pillar-cards.html`) showing 3 recent posts each
3. [ ] Featured post section (auto-populates latest across categories)
4. [ ] SCSS styling (colour tokens, responsive grid, hover states)
5. [ ] Homepage template (`layouts/home.html` or `layouts/index.html` override)
6. [ ] Email signup integration (Mailchimp form embed)

**Content work:**
- [ ] Finalize CTA copy (email signup, LinkedIn, GitHub)
- [ ] Verify all recent posts have featured images (pillar-specific)
- [ ] Test responsive layout on mobile/tablet/desktop

**QA checklist:**
- [ ] All CTAs clickable and working
- [ ] Featured images load correctly (no broken refs)
- [ ] Post counts accurate ("View all X posts")
- [ ] Responsive design tested at 375px, 768px, 1440px
- [ ] Dark mode tested (accent colours apply)
- [ ] Accessibility tested (ARIA labels, keyboard nav, contrast)

**Success metrics:**
- Homepage loads in <3 seconds (Lighthouse Performance > 80)
- Pillar cards clearly differentiate content types
- At least 20% of homepage visitors click a pillar card (trackable via GA)

---

### Phase 2: Depth & Reusability (2–3 weeks post-Phase 1)

**Objective:** Create pillar-specific index pages and reusable shortcodes

**Deliverables:**
1. [ ] Three section pages (`/build/`, `/strategy/`, `/real/`)
   - Pillar-specific hero (colour + messaging)
   - `{{< pillar-list >}}` showing all posts in category
   - Author note explaining the pillar
   - Dedicated CTA (newsletter, GitHub, etc.)

2. [ ] `{{< pillar-list >}}` shortcode
   - Auto-populates posts by category
   - Supports filtering (tags, date range)
   - Shows featured images + excerpts

3. [ ] `{{< cta-button >}}` shortcode for consistent styling

4. [ ] Update Chief of Staff Agents project index
   - New section-style layout showing all sub-pages
   - Visual disambiguation of docs (plan vs strategy vs history vs backlog)

5. [ ] SCSS polish
   - Pillar-specific accent colours per section page
   - Dark mode refinements (link underlines, focus states)
   - Print stylesheet updates

**Content work:**
- [ ] Author intro for `/build/` (200 words)
- [ ] Author intro for `/strategy/` (200 words)
- [ ] Author intro for `/real/` (200 words)
- [ ] Ensure all posts have categories and tags (validation pass)

**QA checklist:**
- [ ] All pillar pages render correctly
- [ ] `{{< pillar-list >}}` shortcode tested with various filters
- [ ] Post counts sync across homepage + section pages
- [ ] Featured image consistency verified
- [ ] Dark mode tested on all pages

**Success metrics:**
- Section pages link from homepage with 30% click-through rate
- Average session duration on section pages > 2 min (vs 1 min blog index)
- Reduced bounce rate on homepage (visitors now have clear next step)

---

### Phase 3: Advanced Features (Optional, post-Phase 2)

**Ideas (deprioritized; revisit if time permits):**
1. [ ] Featured image generation API integration (auto-create pillar-specific images)
2. [ ] Related posts widget (show 3 related posts at bottom of each article)
3. [ ] Reading time estimate per section (estimated time to read all posts in a pillar)
4. [ ] Author social proof (testimonials, speaking engagements, GitHub stars)
5. [ ] Newsletter archive page (all past emails indexed)
6. [ ] Search interface upgrade (filter by pillar, date, tags)

---

## Section 7: Implementation Checklist

### Hugo Files to Create / Modify

**New partials:**
- [ ] `layouts/_partials/hero.html` (60 lines)
- [ ] `layouts/_partials/pillar-cards.html` (80 lines)
- [ ] `layouts/_partials/featured-post.html` (70 lines)
- [ ] `layouts/_partials/cta-section.html` (50 lines)

**New shortcodes:**
- [ ] `layouts/shortcodes/pillar-list.html` (40 lines)
- [ ] `layouts/shortcodes/cta-button.html` (20 lines)

**New/updated templates:**
- [ ] `layouts/home.html` (new, orchestrates partials above)
- [ ] `layouts/page/build/index.html` or content-driven (new)
- [ ] `layouts/page/strategy/index.html` or content-driven (new)
- [ ] `layouts/page/real/index.html` or content-driven (new)

**SCSS:**
- [ ] Extend `assets/scss/common/_variables-custom.scss` (design tokens)
- [ ] Extend `assets/scss/common/_custom.scss` (component styles)

**Content:**
- [ ] `content/build/_index.md` (section intro, if needed)
- [ ] `content/strategy/_index.md` (section intro, if needed)
- [ ] `content/real/_index.md` (section intro, if needed)

**Configuration:**
- [ ] Update `hugo.toml` if section pages need special menu handling
- [ ] No theme changes; only custom overrides

---

### Testing Plan

**Manual testing (per phase):**
1. [ ] Load homepage in Chrome, Firefox, Safari, Edge
2. [ ] Test responsive breakpoints (375px, 480px, 768px, 1440px)
3. [ ] Verify dark mode toggle works and applies accent colours
4. [ ] Click all CTAs; verify destinations load
5. [ ] Featured images display correctly (no distortion)
6. [ ] Post metadata (date, read time) renders accurately
7. [ ] Featured post auto-updates when new post published
8. [ ] Email signup form works (test submission)

**Automated testing (if applicable):**
- [ ] Hugo build completes without warnings (`hugo --printI18nWarnings`)
- [ ] No broken internal links (`hugo --checkOutput`)
- [ ] SCSS compiles without errors

**Performance testing:**
- [ ] Lighthouse audit (target: Performance >80, Accessibility >95)
- [ ] Page size < 2MB (images optimized)
- [ ] First Contentful Paint < 1.5s
- [ ] Cumulative Layout Shift < 0.1

---

### Dependencies & Prerequisites

**Hugo:**
- Version 0.100+ (existing setup, no change needed)

**Theme:**
- hugo-theme-stack (existing, no updates)

**Assets:**
- Space Grotesk font (load from Google Fonts or existing asset)
- Tabler Icons (for pillar section icons, either embedded or via CDN)

**Integrations:**
- Email service (Mailchimp recommended; API key needed)
- Google Analytics (for CTA tracking; already in use)

---

## Section 8: Known Constraints & Decisions

### Architecture Constraints

1. **Stack theme sidebar structure is fixed** — Cannot move to top navigation without major theme refactor. Homepage redesign works within sidebar model (pillar cards appear below hero in main content area).

2. **Featured image workflow** — New posts should include 1200×630px featured image matching pillar gradient. If missing, placeholder (solid colour matching pillar) is used.

3. **Homepage widgets in `hugo.toml`** — Current config shows `[params.widgets] homepage = [search, archives, tag-cloud]`. Phase 1 replaces these with pillar cards. Archives/tag-cloud moved to `/archive/` and `/tags/` respectively (or hidden in sidebar).

4. **No database or CMS** — All data is driven by Hugo front matter (categories, tags, featured images). Pillar detection is via `categories` field in each post.

### Key Decisions

1. **Three section pages (`/build/`, `/strategy/`, `/real/`) are created as `_index.md` files or implicit Hugo sections** — Not manually created HTML pages. This allows automatic discovery and hierarchical organization.

2. **CTA section uses email signup + social links (not multiple conversion funnels)** — Single email integration point; social links from existing `hugo.toml` menu.

3. **Featured post auto-selects latest across all categories** — Not pillar-specific. Ensures homepage always has fresh content.

4. **Pillar card styling uses border-left accent** — Differentiates from article cards (which have top-image). Simpler SCSS override than grid restructuring.

5. **Mobile-first responsive design** — Hero 70vh on mobile (not full screen) to avoid excessive scrolling on small devices.

---

## Section 9: Appendix: Copy Library

### Copy for Phase 1 Implementation

**Hero Section:**
```
B3N.B4UR_

From the server room to the boardroom

Technical Architect at Microsoft CTO Office.
I help enterprises turn AI strategy into systems that ship.

[Explore Posts]  [Learn About Me]
```

**Pillar Card Headlines & CTAs:**
```
🏗️ BUILD
Hands-on architecture, tooling, and scripts for engineers shipping real systems.
→ View all BUILD posts (12)

🗺️ STRATEGY
Frameworks, decision models, and thinking for CTOs and architects.
→ View all STRATEGY posts (8)

🎤 REAL
Leadership lessons, career stories, and honest reflections from 15+ years.
→ View all REAL posts (5)
```

**Featured Post Section:**
```
Latest from B3N.B4UR_

[Post Title]
[Date] · [Read Time] · [Author]

[Excerpt...]

→ Read full post    → Share on LinkedIn
```

**CTA Section:**
```
Stay connected.

Get new posts delivered to your inbox.
[your@email.com]  [Subscribe]

Or follow along on LinkedIn and GitHub:
[LinkedIn: @ben-martin-baur]  [GitHub: @benmartinbaur]
```

---

## Sign-Off & Next Steps

**Document prepared by:** Hugo (Frontend Developer)  
**Review status:** Ready for Ben Martin Baur approval  
**Dependencies:** Clarification needed on email integration (Mailchimp account details)

**Next action:**
1. Review and approve architecture
2. Confirm CTA integration points (email service, social links)
3. Begin Phase 1 implementation

---

> *"From the server room to the boardroom."*
