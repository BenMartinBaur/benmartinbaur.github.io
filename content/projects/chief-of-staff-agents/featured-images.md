# B3N.B4UR_ — Featured Image System

A reusable guide and prompt for generating branded featured images for every blog post.

---

## Overview

Every post on B3N.B4UR_ gets a branded featured image at **1200×630px** (standard OG/social sharing size). The image style is determined by the post's **content pillar** (category).

## Three Pillar Templates

| Pillar | File | Gradient | Use For |
|--------|------|----------|---------|
| 🏗️ **Build** | `assets/img/featured_build_dark.jpg` | `#0C1824` → `#12293D` → `#1E3A52` → `#2A4B6A` | Technical posts: Azure, PowerShell, architecture, IaC, networking |
| 🗺️ **Strategy** | `assets/img/featured_strategy_coral.jpg` | `#F96167` → `#E04470` → `#C5389E` → `#8B44AD` | Framework posts: BXT, CAF, CoE, cheatsheets, decision tools |
| 🎤 **Real** | `assets/img/featured_real_blue.jpg` | `#89B4E8` → `#A8A0E0` → `#D4A0D0` → `#E8C0D4` | Personal posts: career stories, reflections, values, lessons learned |

## Brand Elements

| Element | Value |
|---------|-------|
| **Logo** | B3N.B4UR_ (numbers 3 & 4 in accent colour) |
| **Logo font** | Space Grotesk Bold, letter-spacing .06em |
| **Accent colour** | `#F96167` (Coral Energy) — used on numbers and underscore |
| **Strategy accent** | `#FFD54F` (Gold) — used on numbers in Strategy images (better contrast on coral bg) |
| **Attribution** | "Ben Martin Baur" in Inter, 13px, low opacity |
| **Pillar badge** | Top-left, 13px uppercase, pillar-specific colour |

## Layout Rules

```
┌─────────────────────────────────────────────┐
│ 🏗️ BUILD (pillar badge, top-left)          │
│                                             │
│                         (decorative element │
│                          top-right, subtle) │
│                                             │
│                                             │
│ Post Title                                  │
│ Line Two If Needed                          │
│ Subtitle in smaller text, lower opacity     │
│ B3N.B4UR_ | Ben Martin Baur                │
└─────────────────────────────────────────────┘
```

- **Title**: Space Grotesk, 44–52pt bold, white, max 2 lines
- **Subtitle**: Inter, 16px, white at 45–70% opacity
- **Logo + name**: Bottom-left, separated by a 1px divider line
- **Padding**: 60px vertical, 70px horizontal
- **Content area**: max-width 700–750px (left-aligned)

## Decorative Elements Per Pillar

| Pillar | Decoration |
|--------|------------|
| **Build** | Subtle grid overlay (40px squares, ~4% opacity blue lines). Faint terminal commands top-right in JetBrains Mono. `> ssh build@b3n.b4ur_` |
| **Strategy** | Subtle concentric circles top-right (2px white border, ~5-8% opacity). Radial light bloom at 80% 20% |
| **Real** | Soft `✦` symbol top-right at ~8% opacity. Radial light bloom at 75% 25% |

---

## Reusable Prompt

Copy-paste this prompt to any AI to generate a new featured image:

```
Create a branded featured image for a blog post using the B3N.B4UR_ visual identity system.

**Post details:**
- Title: [POST TITLE]
- Subtitle: [ONE-LINE DESCRIPTION]
- Pillar: [build / strategy / real]

**Specifications:**
- Dimensions: 1200×630px
- Background: Use the pillar gradient:
  - Build: linear-gradient(135deg, #0C1824 0%, #12293D 30%, #1E3A52 60%, #2A4B6A 100%) with subtle 40px grid overlay at 4% opacity
  - Strategy: linear-gradient(135deg, #F96167 0%, #E04470 30%, #C5389E 60%, #8B44AD 100%) with subtle concentric circles top-right
  - Real: linear-gradient(135deg, #89B4E8 0%, #A8A0E0 30%, #D4A0D0 60%, #E8C0D4 100%) with soft radial light bloom
- Pillar badge: Top-left, emoji + pillar name, 13px uppercase, letter-spacing .12em
  - Build colour: #64B5F6
  - Strategy colour: #FFD54F
  - Real colour: rgba(255,255,255,.85)
- Title: Space Grotesk Bold, 44-52px, white, bottom-left, max 2 lines, line-height 1.15
- Subtitle: Inter 16px, white at 45-70% opacity depending on pillar, below title
- Logo: "B3N.B4UR_" in Space Grotesk Bold 16px, white, letter-spacing .06em
  - Numbers 3 and 4 in accent colour (#F96167 for Build/Real, #FFD54F for Strategy)
  - Underscore in same accent colour
- Divider: 1px white line at 15-25% opacity between logo and name
- Attribution: "Ben Martin Baur" in Inter 13px, white at 30-50% opacity
- Padding: 60px top/bottom, 70px left/right
- Content max-width: 750px, aligned bottom-left

The background template images (without text) are available at:
- assets/img/featured_build_dark.jpg
- assets/img/featured_strategy_coral.jpg
- assets/img/featured_real_blue.jpg

Save the output as featured.jpg inside the post's directory.
```

---

## Existing Featured Images

| Post | Pillar | Image |
|------|--------|-------|
| Intune & W365 Naming | 🏗️ Build | ✅ Generated |
| Azure Default Outbound | 🏗️ Build | ✅ Had existing |
| BXT Framework Cheatsheet | 🗺️ Strategy | ✅ Had existing |
| Frontier CoE meets Cloud CoE | 🗺️ Strategy | ✅ Had existing |
| CAF vs AI Adoption Framework | 🗺️ Strategy | ✅ Generated |
| Let's Get Real Cheatsheet | 🗺️ Strategy | ✅ Had existing |
| Welcome to the Boardroom | 🗺️ Strategy | ✅ Generated |
| Business Envisioning | 🗺️ Strategy | ✅ Generated |
| First 30 Days (photo) | 🎤 Real | ✅ Had existing |
| First 30 Days (conversations) | 🎤 Real | ✅ Had existing |
| Vegan — My Story | 🎤 Real | ✅ Had existing |
| AI Chief of Staff | 🎤 Real | ✅ Generated |
