#!/usr/bin/env bash
set -euo pipefail

# Ensure script is executable
chmod +x user/assets/convert_image_to_html.sh

# Run conversion
./user/assets/convert_image_to_html.sh

# Verify that an HTML file was generated for each slide directory
missing=0
for dir in user/assets/slides/slide-*/; do
  base=$(basename "$dir")
  html_file="$dir/${base}.html"
  if [[ ! -f "$html_file" ]]; then
    echo "Missing HTML file: $html_file"
    missing=1
  else
    echo "Found: $html_file"
  fi
done

if [[ $missing -eq 1 ]]; then
  echo "One or more HTML files missing. Test failed."
  exit 1
else
  echo "All HTML files generated successfully. Test passed."
fi
