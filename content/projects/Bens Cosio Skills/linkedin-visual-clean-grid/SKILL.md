---
name: linkedin-visual-clean-grid
description: Create clean, minimal LinkedIn post visuals and blog featured images in a reusable grid style (off-white background, subtle grid, corner marks, centered headline/subheadline). Use this skill whenever the user asks for a LinkedIn visual, social image, featured image, quote card, title card, or wants image text styling/casing fixed — even if they only say "make it look like this example."
---

# LinkedIn Visual Clean Grid

Use this skill to create reusable social visuals with one consistent design system and predictable output files.

## What this skill produces
1. `*.svg` source visual (editable master).
2. `*.jpg` export (LinkedIn-ready).

Default canvas:
- **1200 x 628** for LinkedIn
- **1200 x 630** for blog featured images when requested

## Design system (B3N clean grid style)

Core look:
1. Warm off-white background (`#f7f5f0`)
2. Subtle square grid (`#e8e7e3`, 24px spacing)
3. Minimal corner marks (top-left and bottom-right, dark navy)
4. Centered headline and centered subheadline
5. No heavy boxes, no icons, no decorative clutter

Typography:
- Headline: dark navy `#1f2b3a`, bold, large
- Subheadline: slate `#3e4b5e`, regular, smaller
- Font family: `Inter, Arial, sans-serif`

## Header writing rules (critical)
1. Use **sentence case**, not title case.
2. Keep punctuation intentional and clean.
3. Use straight or smart apostrophes consistently.
4. Keep headline to 1-2 lines; subheadline to 1 line where possible.

Example:
- Correct: `Don't count every token. Make every token count.`
- Avoid: `Don't Count Every Token, Make Every Token Count.`

## Workflow
1. Capture message objective (hook, audience, intent).
2. Draft short headline + subheadline in sentence case.
3. Generate SVG using the style system.
4. Export JPG with high quality for LinkedIn.
5. If user requests text changes, update SVG first, then regenerate JPG.

## SVG structure contract
Use this structure for consistency:
1. `<defs>` with 24px grid pattern
2. Full-bleed background rectangle
3. Full-bleed grid overlay rectangle
4. Two corner mark paths
5. Headline text block (1-2 lines)
6. Subheadline text block

## JPG export
Preferred conversion path:
- Use `sharp` to render SVG -> JPG
- Preserve background color and high readability

Recommended settings:
- `density: 300`
- `jpeg quality: 92`
- `chromaSubsampling: 4:4:4`
- flatten background: `#f7f5f0`

## Output naming
Use deterministic naming with an incrementing series id:
- `visual-00-series-intro.svg`
- `visual-00-series-intro.jpg`

For blog post featured images:
- `featured.svg` (optional editable master)
- `featured.jpg` (published image)

## Quality checks before finalizing
1. Headline is sentence case.
2. No overflow/cropping at 1200px width.
3. Contrast is readable on mobile.
4. SVG and JPG filenames match (same stem).
5. Subheadline supports, not repeats, headline.

## Reference
- Style tokens and a reusable template are in `references/style-spec.md`.
