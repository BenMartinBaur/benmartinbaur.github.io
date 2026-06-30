"""
Automate Agent Design Canvas PPTX generation from markdown content.

This script replaces the manual unpack→edit→clean→pack workflow by:
1. Copying the template
2. Extracting 10 canvas sections from markdown
3. Editing the XML directly with proper formatting
4. Repacking into PPTX

Usage:
    python generate_pptx.py <canvas.md> <output.pptx> [--template <path-to-template>]

The markdown should contain 10 sections with headers like:
    ## 1. Goal
    ## 2. Triggers
    ... etc
"""

import argparse
import json
import re
import shutil
import sys
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path
from zipfile import ZipFile


# Register namespaces to preserve prefixes
NAMESPACES = {
    "a": "http://schemas.openxmlformats.org/drawingml/2006/main",
    "p": "http://schemas.openxmlformats.org/presentationml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
    "pic": "http://schemas.openxmlformats.org/drawingml/2006/picture",
}

for prefix, uri in NAMESPACES.items():
    ET.register_namespace(prefix, uri)


def extract_sections(markdown_path: str) -> dict:
    """Extract 10 canvas sections from markdown.
    
    Returns dict mapping section names to condensed content (2-4 sentences).
    """
    with open(markdown_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    sections = {}
    section_order = [
        "Goal", "Triggers", "Channels", "Knowledge and Data",
        "Tools and Integrations", "Flows and Orchestration",
        "Instructions and Behavior", "Agent Architecture",
        "Governance & Risk", "Evaluation and Optimization"
    ]
    
    for section_name in section_order:
        # Match ## N. Section Name or ## Section Name
        pattern = rf"##\s+\d*\.?\s*{re.escape(section_name)}.*?\n(.*?)(?=##\s+\d|$)"
        match = re.search(pattern, content, re.IGNORECASE | re.DOTALL)
        
        if match:
            raw_content = match.group(1).strip()
            # Extract 2-4 sentences (rough heuristic: split on ". " and take first 3-4)
            sentences = [s.strip() for s in raw_content.split(". ") if s.strip()]
            condensed = ". ".join(sentences[:4])
            if not condensed.endswith("."):
                condensed += "."
            sections[section_name] = condensed
        else:
            sections[section_name] = "[Not provided]"
    
    return sections


def escape_xml_text(text: str) -> str:
    """Escape text for XML, convert smart quotes to XML entities."""
    text = text.replace("&", "&amp;")
    text = text.replace("<", "&lt;")
    text = text.replace(">", "&gt;")
    text = text.replace('"', "&quot;")
    text = text.replace("'", "&#x2019;")
    text = text.replace(""", "&#x201C;")
    text = text.replace(""", "&#x201D;")
    return text


def update_pptx_content(pptx_path: str, sections: dict, output_path: str) -> None:
    """
    Extract PPTX, update slide1.xml with canvas sections, repack.
    
    Canvas cell mapping:
    - Row 1: Goal (gridSpan=2)
    - Row 2: Triggers | Channels
    - Row 3: Knowledge and Data | Tools and Integrations
    - Row 4: Flows and Orchestration | Instructions and Behavior
    - Row 5: Agent Architecture | Governance & Risk
    - Row 6: Evaluation and Optimization (gridSpan=2)
    """
    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir_path = Path(tmpdir)
        unpacked_dir = tmpdir_path / "unpacked"
        
        # Extract PPTX
        with ZipFile(pptx_path, "r") as z:
            z.extractall(unpacked_dir)
        
        # Edit slide1.xml
        slide_xml_path = unpacked_dir / "ppt" / "slides" / "slide1.xml"
        tree = ET.parse(slide_xml_path)
        root = tree.getroot()
        
        # Find table
        ns = NAMESPACES
        table = root.find(".//a:tbl", ns)
        if table is None:
            raise ValueError("No table found in slide1.xml")
        
        # Get all rows
        rows = table.findall("a:tr", ns)
        if len(rows) < 6:
            raise ValueError(f"Expected at least 6 rows, found {len(rows)}")
        
        # Cell mapping: (row_idx, col_idx) -> section_name
        cell_map = {
            (0, 0): "Goal",
            (1, 0): "Triggers",
            (1, 1): "Channels",
            (2, 0): "Knowledge and Data",
            (2, 1): "Tools and Integrations",
            (3, 0): "Flows and Orchestration",
            (3, 1): "Instructions and Behavior",
            (4, 0): "Agent Architecture",
            (4, 1): "Governance & Risk",
            (5, 0): "Evaluation and Optimization",
        }
        
        for row_idx, row in enumerate(rows):
            cells = row.findall("a:tc", ns)
            for col_idx, cell in enumerate(cells):
                key = (row_idx, col_idx)
                if key not in cell_map:
                    continue
                
                section_name = cell_map[key]
                content = sections.get(section_name, "[Not provided]")
                content_escaped = escape_xml_text(content)
                
                # Find the gray description paragraph
                txBody = cell.find("a:txBody", ns)
                if txBody is None:
                    continue
                
                # Find paragraphs with gray text (color #A5A5A5)
                for p in txBody.findall("a:p", ns):
                    runs = p.findall("a:r", ns)
                    for run in runs:
                        rPr = run.find("a:rPr", ns)
                        if rPr is not None:
                            solidFill = rPr.find("a:solidFill", ns)
                            if solidFill is not None:
                                srgbClr = solidFill.find("a:srgbClr", ns)
                                if srgbClr is not None and srgbClr.get("val") == "A5A5A5":
                                    # This is the gray description text; replace it
                                    t_elem = run.find("a:t", ns)
                                    if t_elem is not None:
                                        t_elem.text = content_escaped
                                        # Set xml:space="preserve" if content has leading/trailing space
                                        if content_escaped != content_escaped.strip():
                                            t_elem.set("{http://www.w3.org/XML/1998/namespace}space", "preserve")
        
        # Write updated XML
        tree.write(slide_xml_path, encoding="utf-8", xml_declaration=True)
        
        # Repack PPTX
        with ZipFile(output_path, "w") as z:
            for item_path in unpacked_dir.rglob("*"):
                if item_path.is_file():
                    arcname = item_path.relative_to(unpacked_dir)
                    z.write(item_path, arcname)


def main():
    parser = argparse.ArgumentParser(
        description="Generate Agent Design Canvas PPTX from markdown"
    )
    parser.add_argument("markdown", help="Path to canvas markdown file")
    parser.add_argument("output", help="Output PPTX file path")
    parser.add_argument(
        "--template",
        default=None,
        help="Path to template PPTX (default: assets/Agent-Design-Canvas.pptx in skill dir)"
    )
    
    args = parser.parse_args()
    
    # Resolve template path
    if args.template is None:
        script_dir = Path(__file__).parent
        skill_dir = script_dir.parent
        args.template = str(skill_dir / "assets" / "Agent-Design-Canvas.pptx")
    
    if not Path(args.template).exists():
        print(f"Error: Template not found at {args.template}", file=sys.stderr)
        sys.exit(1)
    
    if not Path(args.markdown).exists():
        print(f"Error: Markdown file not found at {args.markdown}", file=sys.stderr)
        sys.exit(1)
    
    try:
        print(f"Extracting canvas sections from {args.markdown}...")
        sections = extract_sections(args.markdown)
        
        print(f"Copying template from {args.template}...")
        with tempfile.NamedTemporaryFile(suffix=".pptx", delete=False) as tmp:
            tmp_pptx = tmp.name
            shutil.copy(args.template, tmp_pptx)
        
        print(f"Updating PPTX content...")
        update_pptx_content(tmp_pptx, sections, args.output)
        
        print(f"✓ Generated {args.output}")
        print("\nCanvas sections included:")
        for section, content in sections.items():
            preview = content[:60] + "..." if len(content) > 60 else content
            print(f"  • {section}: {preview}")
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        if 'tmp_pptx' in locals() and Path(tmp_pptx).exists():
            Path(tmp_pptx).unlink()


if __name__ == "__main__":
    main()
