"""Extract clean text from a VTT transcript file.

Usage:
    python extract_vtt.py <input.vtt> [output.txt]

Strips timestamps, speaker tags, WEBVTT headers, and segment IDs.
Outputs one continuous text block suitable for analysis.
"""

import re
import sys


def extract_text(vtt_path: str) -> str:
    with open(vtt_path, "r", encoding="utf-8") as f:
        content = f.read()

    lines = []
    for line in content.split("\n"):
        line = line.strip()
        # Skip WEBVTT header
        if line == "WEBVTT":
            continue
        # Skip empty lines
        if not line:
            continue
        # Skip timestamp lines (00:01:23.456 --> 00:01:25.789)
        if re.match(r"^\d{2}:\d{2}:\d{2}\.\d{3}\s*-->", line):
            continue
        # Skip segment IDs (UUID-style or numeric)
        if re.match(r"^[0-9a-f]{8}-[0-9a-f]{4}-", line):
            continue
        if re.match(r"^\d+$", line):
            continue
        # Strip speaker tags: <v @1>text</v>
        line = re.sub(r"<v\s+@\d+>", "", line)
        line = re.sub(r"</v>", "", line)
        line = line.strip()
        if line:
            lines.append(line)

    # Join into continuous text, collapsing whitespace
    text = " ".join(lines)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <input.vtt> [output.txt]", file=sys.stderr)
        sys.exit(1)

    vtt_path = sys.argv[1]
    text = extract_text(vtt_path)

    if len(sys.argv) >= 3:
        output_path = sys.argv[2]
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(text)
        print(f"Extracted {len(text)} characters to {output_path}")
    else:
        print(text)


if __name__ == "__main__":
    main()
