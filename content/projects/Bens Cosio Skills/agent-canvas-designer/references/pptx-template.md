# PowerPoint Template Reference

## Template Location

`assets/Agent-Design-Canvas.pptx`

## Design Specifications

- **Slide size**: Widescreen 16:9 (12192000 x 6858000 EMU)
- **Theme**: "Microsoft Innovation Hub" branded (LIGHT MODE slide master)
- **Color scheme** (name: "Microsoft Innovation Hub - Dark Mode"):
  - dk1: `#091F2C` (dark navy)
  - lt1: `#FFFFFF` (white)
  - dk2: `#091F2D`
  - lt2: `#FFF8F3` (warm cream)
  - accent1: `#FFA38B` (coral)
  - accent2: `#C2B4E2` (lavender)
  - accent3: `#BF3AC5` (magenta)
  - accent4: `#0077D3` (blue)
  - accent5: `#8DC7E8` (sky blue)
  - accent6: `#8CE970` (green)
- **Fonts**: Segoe UI Semibold (major/headings), Segoe UI (minor/body)

## Table Layout (Single Slide)

The slide contains one table positioned at:
- Offset: x=558459, y=1147603
- Size: cx=10886883, cy=5134753

Two columns:
- Column 1: w=5426047
- Column 2: w=5460836

Six rows (h=837365 each):
1. **Row 1** (gridSpan=2): Use Case Description (Goal)
2. **Row 2**: Triggers | Channels
3. **Row 3**: Knowledge and Data | Tools and Integrations
4. **Row 4**: Flows and Orchestration | Instructions and Behavior
5. **Row 5**: Agent Architecture and Components | Governance & Risk Management
6. **Row 6** (gridSpan=2): Evaluation and Optimization

## Cell Text Formatting

Each cell contains:
1. **Section header**: Bold, 11pt (sz="1100"), kern="100"
2. **Description/content**: Regular, 10.5pt (sz="1050"), kern="1200", gray fill (`#A5A5A5`)
3. **Spacer paragraph**: 10.5pt with line spacing 115% and 800pt after-spacing

Cell margins: marL="8239", marR="8239", marT="0", marB="0"
Table style: `{C4B1156A-380E-4F78-BDF5-A606A8083BF9}`

## Editing Process

When filling the template with content:

1. **Keep section headers** — The bold text (e.g., "Use case description (Goal)") stays unchanged
2. **Replace gray description text** — The `<a:r>` elements with `<a:solidFill><a:srgbClr val="A5A5A5"/>` contain placeholder descriptions. Replace their `<a:t>` content with extracted canvas data
3. **Preserve formatting runs** — Keep `<a:rPr>` attributes intact; only change `<a:t>` text content
4. **Handle split runs** — Some descriptions span multiple `<a:r>` elements (e.g., "Jobs To Be Done" is bold within a gray run). When replacing, you may need to remove extra runs and consolidate text into one run
5. **Watch for smart quotes** — The template uses literal Unicode characters (e.g., U+2019 for apostrophe), not XML entities

## Validation

After editing and repacking, the pack script auto-repairs:
- Missing `xml:space="preserve"` on whitespace-containing `<a:t>` elements

All content should render correctly in PowerPoint, Keynote, and Google Slides.
