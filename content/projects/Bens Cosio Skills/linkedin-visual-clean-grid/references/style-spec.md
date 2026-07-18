# LinkedIn Visual Clean Grid - Style Spec

## Purpose
Reusable spec for creating clean title-card visuals for LinkedIn posts and blog featured images.

## Canvas
- LinkedIn: `1200 x 628`
- Blog featured: `1200 x 630`

## Color tokens
- Background: `#f7f5f0`
- Grid line: `#e8e7e3`
- Primary text: `#1f2b3a`
- Secondary text: `#3e4b5e`

## Grid
- Pattern size: `24 x 24`
- Stroke width: `1`
- Full-canvas overlay

## Corner marks
- Stroke: `#1f2b3a`
- Stroke width: `3`
- Top-left:
  - horizontal: `(42,28) -> (78,28)`
  - vertical: `(42,28) -> (42,64)`
- Bottom-right:
  - horizontal: `(1158,600) -> (1122,600)` (or y=602 on 630 canvases)
  - vertical: `(1158,600) -> (1158,564)` (or y=566 on 630 canvases)

## Typography
- Family: `Inter, Arial, sans-serif`
- Headline:
  - Weight: `700`
  - Size range: `50-58px`
  - Align: centered
  - Lines: 1-2
- Subheadline:
  - Weight: `400`
  - Size range: `30-38px`
  - Align: centered
  - Lines: 1 (preferred), max 2

## Copy style
1. Sentence case
2. Plain language
3. Strong noun/verb framing
4. No jargon stacking

## Minimal SVG template
```xml
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="628" viewBox="0 0 1200 628">
  <defs>
    <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
      <path d="M 24 0 L 0 0 0 24" fill="none" stroke="#e8e7e3" stroke-width="1"/>
    </pattern>
  </defs>
  <rect width="1200" height="628" fill="#f7f5f0"/>
  <rect width="1200" height="628" fill="url(#grid)"/>

  <path d="M42 28 H78 M42 28 V64" stroke="#1f2b3a" stroke-width="3" fill="none"/>
  <path d="M1158 600 H1122 M1158 600 V564" stroke="#1f2b3a" stroke-width="3" fill="none"/>

  <text x="600" y="286" text-anchor="middle" font-family="Inter, Arial, sans-serif" font-size="54" font-weight="700" fill="#1f2b3a">
    "Headline line one
  </text>
  <text x="600" y="350" text-anchor="middle" font-family="Inter, Arial, sans-serif" font-size="54" font-weight="700" fill="#1f2b3a">
    line two"
  </text>
  <text x="600" y="430" text-anchor="middle" font-family="Inter, Arial, sans-serif" font-size="34" fill="#3e4b5e">
    Supporting subheadline here.
  </text>
</svg>
```

## Conversion command (Node + sharp)
```powershell
$dir='C:\path\to\visuals'
@'
const fs = require('fs');
const path = require('path');
const sharp = require('sharp');
const dir = process.argv[2];
(async () => {
  for (const file of fs.readdirSync(dir).filter(f => f.endsWith('.svg')).sort()) {
    const inPath = path.join(dir, file);
    const outPath = path.join(dir, file.replace(/\.svg$/i, '.jpg'));
    await sharp(inPath, { density: 300 })
      .flatten({ background: '#f7f5f0' })
      .jpeg({ quality: 92, chromaSubsampling: '4:4:4' })
      .toFile(outPath);
    console.log(outPath);
  }
})().catch(err => { console.error(err); process.exit(1); });
'@ | node - $dir
```
