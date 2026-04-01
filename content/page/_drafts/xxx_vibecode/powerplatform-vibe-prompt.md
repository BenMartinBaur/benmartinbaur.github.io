Build an "Innovation Hub Academy — Training Catalog" Power App (canvas app) that looks and works like the following specification. This is a single-screen responsive app with filtering, search, and a registration modal.

---

## BRAND KIT (use these exact values)

### Colors
- Frontier Blue: #4F6BF6 — primary brand color, headers, CTAs, links
- Innovation Pink: #E84393 — highlights, accent text
- Academy Lavender: #A78BFA — secondary accent, tags, badges
- Surface: #FFFFFF — card backgrounds
- Canvas: #F8FAFC — page background
- Subtle: #F1F5F9 — secondary fills, dividers
- Text Primary: #1E293B — headings, body text
- Text Secondary: #64748B — captions, descriptions, metadata
- Primary Gradient: #4F6BF6 → #A78BFA → #E84393 (135deg)

### Typography
- Headings: Segoe UI Semibold, 28–42px
- Body: Segoe UI Regular, 16px
- Labels/badges: Segoe UI Medium, 13–14px, uppercase, letter-spacing

---

## PAGE LAYOUT

### 1. HERO HEADER (top, white background)
- Clean white background, no image
- Logo text: "INNOVATION HUB ACADEMY" in uppercase Segoe UI Semibold 14px, where "ACADEMY" is colored #E84393
- Vertical divider (1px, 16px tall) then "Training Catalog" in 12px muted text
- Main heading: "Unlocking Potential. Building What's Next." in Segoe UI Bold 42px, color #1E293B
- Subtitle: "Register for hands-on trainings led by our Innovation Hub architects — from envisioning to rapid prototypes." in 17px, color #64748B
- Below the hero: a 4px gradient bar (the primary gradient #4F6BF6 → #A78BFA → #E84393)

### 2. STICKY FILTER BAR (below gradient bar, sticks to top on scroll)
- White background, 1px bottom border #E2E8F0, subtle shadow
- Label: "ARCHITECT" in uppercase 13px #64748B
- Filter chips (pill-shaped buttons, border-radius 100px):
  - "All" chip — active by default (filled #4F6BF6, white text)
  - One chip per architect: Andreas, Ben, Jacqueline, Timm, Sven, Dominik, Tobias
  - Each architect chip shows a small circular avatar (24px) next to their name
  - Inactive chips: white background, #E2E8F0 border, #64748B text
  - Active chip: #4F6BF6 background, white text, avatar gets 2px white ring
  - Hover: blue border, light blue background #EEF2FF
- Right side: search input with magnifying glass icon, rounded pill shape, 240px wide
- Clicking a chip filters the training cards to show only that architect's trainings
- Search filters by title, description, track, and architect name

### 3. STATS BAR
- Shows "[count] trainings available" where count updates based on active filters

### 4. TRAINING CARD GRID
- Responsive grid: 3 columns on desktop (min 340px per card), 1 column on mobile
- Gap: 24px between cards

Each card has:
- **Card image** (top, 200px height, object-fit cover) — use placeholder gradient backgrounds in these colors:
  - Architecture Design: light blue-to-purple gradient
  - Business Envisioning: light pink-to-blue gradient
  - Solution Envisioning: lavender-to-pink gradient
  - Rapid Prototype: blue-to-green gradient
  - Hackathon: orange-to-pink gradient
  - (or use any relevant placeholder image)
- **Track badge** (top-left of image, pill shape, blurred backdrop):
  - "🤝 CONSULTATIVE SELLING" — blue (#2563EB at 85% opacity)
  - "✦ FRONTIER TECHNOLOGY" — pink (#DB2777 at 85% opacity)
  - "🧭 LEADERSHIP & CULTURE" — purple (#7C3AED at 85% opacity)
- **Duration badge** (bottom-right of image): dark semi-transparent pill, white text
- **Card body** (white, padded 20px 24px):
  - Title: Space Grotesk / Segoe UI Semibold 18px
  - Description: 14px #64748B, 1.5 line-height
  - Bottom meta row (border-top 1px #F1F5F9):
    - Left: architect avatar (32px circle) + name (13px semibold) + role (11px muted)
    - Right: **"Register"** button — gradient background (#4F6BF6 → #A78BFA → #E84393), white text, pill shape, uppercase 13px semibold
- **Hover effect**: card lifts 4px, gets a blue/lavender shadow

### 5. REGISTRATION MODAL
- Triggered by clicking "Register" on any card
- Dark overlay with blur backdrop
- White modal (border-radius 20px, max-width 480px):
  - Close button (top-right, circle, ✕)
  - Title: "Register" in Segoe UI Semibold 22px
  - Subtitle: the training name in 14px muted
  - Form fields (10px border-radius, #F8FAFC background, #E2E8F0 border):
    - Full Name (text input)
    - Email (email input, placeholder "alias@microsoft.com")
    - Role (dropdown: Solution Architect, Technical Specialist, Account Executive, Consultant, Other)
  - "Register Now" button — full width, gradient background, pill shape, white text
  - On submit: show success state with green checkmark circle, "You're registered!" heading, and detail text
- Close on overlay click or Escape key

### 6. FOOTER
- White background, border-top #E2E8F0
- Text: "Innovation Hub Academy · Microsoft Innovation Hub · © 2026"
- "Academy" colored #E84393

---

## TRAINING DATA (12 trainings)

| # | Title | Track | Duration | Architect | Role |
|---|-------|-------|----------|-----------|------|
| 1 | Architecture Design Session | ✦ Frontier Technology | Full Day | Andreas | Solution Architect |
| 2 | Business Envisioning Workshop | 🤝 Consultative Selling | Half Day | Ben | Lead Architect |
| 3 | Solution Envisioning Masterclass | 🤝 Consultative Selling | Full Day | Jacqueline | Solution Architect |
| 4 | Rapid Prototyping Lab | ✦ Frontier Technology | Full Day | Timm | Technical Architect |
| 5 | Hackathon: Innovation Sprint | ✦ Frontier Technology | 2 Days | Sven | Innovation Architect |
| 6 | BXT Framework Deep Dive | 🧭 Leadership & Culture | Half Day | Dominik | Strategy Architect |
| 7 | Design Thinking for Sellers | 🧭 Leadership & Culture | Half Day | Tobias | Design Architect |
| 8 | Rapid Prototype & Hackathon Combo | ✦ Frontier Technology | 2 Days | Andreas | Solution Architect |
| 9 | Consultative Selling Foundations | 🤝 Consultative Selling | Half Day | Ben | Lead Architect |
| 10 | Digital Agents: Strategy & Architecture | ✦ Frontier Technology | Full Day | Sven | Innovation Architect |
| 11 | Leadership Coaching Circle | 🧭 Leadership & Culture | 2 Hours | Jacqueline | Solution Architect |
| 12 | Whiteboarding Masterclass | 🤝 Consultative Selling | Half Day | Dominik | Strategy Architect |

### Training Descriptions
1. "Collaborative deep-dive into customer solution architecture. Learn to facilitate ADS sessions that turn complex requirements into actionable blueprints."
2. "Master the art of business envisioning — from stakeholder alignment to outcome-driven roadmaps. Build the bridge between customer ambition and technical execution."
3. "Translate business outcomes into solution designs. Practice structured envisioning with real customer scenarios and walk away with reusable frameworks."
4. "From whiteboard to working prototype in one day. Learn rapid prototyping techniques that demonstrate value to customers and accelerate decision-making."
5. "Two-day intensive hackathon combining AI, Digital Agents, and customer challenges. Build real solutions with cross-functional teams and present to leadership."
6. "Business, Experience, and Technology — the trifecta of great customer engagements. Learn to apply BXT thinking across every stage of the sales cycle."
7. "Apply design thinking to customer conversations. Empathize, define, ideate, prototype, test — the innovation mindset that turns sellers into trusted advisors."
8. "The ultimate hands-on experience — start with structured rapid prototyping, then compete in a hackathon sprint. Best prototypes get fast-tracked to customers."
9. "The fundamentals of consultative selling — structured discovery, value articulation, and executive storytelling. Build the foundation for every customer conversation."
10. "Digital Agents sit at the intersection of IT and human labor. Learn to architect agent solutions and position them for maximum customer impact."
11. "Peer coaching session for senior consultants. Share field patterns, challenge each other's approaches, and elevate the team's consultative capabilities together."
12. "Transform complex ideas into clear visual stories at the whiteboard. Practice structured whiteboarding techniques that engage executives and technical audiences alike."

---

## INTERACTION BEHAVIOR

1. **Filter chips**: clicking an architect chip makes it active (filled blue), deactivates others, and filters the grid to only that architect's trainings. Clicking "All" resets.
2. **Search**: typing in the search box live-filters cards by title, description, track label, or architect name. Works in combination with the architect filter.
3. **Card count**: the stats bar count updates whenever filters change.
4. **Register button**: opens the modal pre-filled with the training title. Form validates name and email before submission.
5. **Animations**: cards fade up on load with staggered delays. Cards lift on hover.

---

## KEY DESIGN PRINCIPLES
- Clean, airy, professional — no clutter
- Glass-morphism accent elements (frosted blur on badges)
- Iridescent gradient used sparingly on CTAs and the gradient bar — never as full backgrounds
- The brand is light and open — white/light gray backgrounds only
- Mobile-responsive: single column on small screens, filter bar wraps
