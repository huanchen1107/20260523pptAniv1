#!/usr/bin/env bash
set -euo pipefail

# Verify that storyboard HTML files are generated for each slide and contain required attributes.

SLIDES_ROOT="user/assets/slides"
STORYBOARDS_DIR="user/assets/storyboards"

# Run the generation script first (in case files are missing)
./user/assets/generate_storyboard.sh

# Iterate over slide directories
declare -a missing=()
declare -a bad=()

for slide_dir in "$SLIDES_ROOT"/slide-*/; do
  slide_name=$(basename "$slide_dir")
  storyboard_file="${slide_dir}/${slide_name}-storyboard.html"
  if [[ ! -f "$storyboard_file" ]]; then
    missing+=("$slide_name")
    continue
  fi
  # Check for HyperFrames data attributes
  if ! grep -q "data-hf-timeline=\"${slide_name}\"" "$storyboard_file"; then
    bad+=("$slide_name (missing data-hf-timeline)")
  fi
  if ! grep -q "data-hf-fps=\"30\"" "$storyboard_file"; then
    bad+=("$slide_name (missing data-hf-fps)")
  fi
  if ! grep -q "data-hf-duration=\"150\"" "$storyboard_file"; then
    bad+=("$slide_name (missing data-hf-duration)")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Error: Missing storyboard files for slides: ${missing[*]}"
  exit 1
fi

if [[ ${#bad[@]} -gt 0 ]]; then
  echo "Error: Storyboard files missing required attributes: ${bad[*]}"
  exit 1
fi

echo "All storyboard files generated and contain required attributes."
exit 0
