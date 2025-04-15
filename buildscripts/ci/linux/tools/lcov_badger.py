import io
import sys

USAGE = "Usage: python lcov-badger.py (path-to-info-file) (path-for-output-svg)"

SVG_TEMPLATE = """<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="106" height="20" role="img" aria-label="Coverage: 100%">
        <linearGradient id="s" x2="0" y2="100%">
                <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
                <stop offset="1" stop-opacity=".1"/>
        </linearGradient>
        <clipPath id="r">
                <rect width="106" height="20" rx="3" fill="#fff"/>
        </clipPath>
        <g clip-path="url(#r)">
                <rect width="63" height="20" fill="#555"/>
                <rect x="63" width="43" height="20" fill="#4c1"/>
                <rect width="106" height="20" fill="url(#s)"/>
        </g>
        <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" text-rendering="geometricPrecision" font-size="110">
                <text aria-hidden="true" x="325" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="530">Coverage</text>
                <text x="325" y="140" transform="scale(.1)" fill="#fff" textLength="530">Coverage</text>
                <text aria-hidden="true" x="835" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="330">{{PERCENT}}%</text>
                <text x="835" y="140" transform="scale(.1)" fill="#fff" textLength="330">{{PERCENT}}%</text>
        </g>
</svg>"""

def create_svg(percent):
    return SVG_TEMPLATE.replace("{{PERCENT}}", str(percent))

def extract_coverage(lcov_file):
    tested_lines = 0
    total_lines = 0

    with open(lcov_file, 'r') as file:
        for line in file:
            if line.startswith('DA'):
                total_lines += 1
                if not line.strip().endswith(',0'):
                    tested_lines += 1

    return int(round((tested_lines / total_lines) * 100))

if (len(sys.argv) != 3):
    print(USAGE)
    exit(-1)

source_path = sys.argv[1]
svg_path = sys.argv[2]
print("Reading coverage info from " + source_path)

coverage = extract_coverage(source_path)
print("Coverage is " + coverage)

badge_data = create_svg(coverage)

print(repr(SVG_TEMPLATE))

print("Creating a coverage badge " + svg_path)
with open(svg_path, 'w') as badge_file:
    badge_file.write(badge_data)
