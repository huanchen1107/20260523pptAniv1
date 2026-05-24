#!/usr/bin/env bash
set -euo pipefail

# Verify that animation MP4 files are generated for each slide.

SLIDES_ROOT="user/assets/slides"

# Run the generation scripts first (in case files are missing)
./user/assets/generate_storyboard.sh
./user/assets/render_animation.sh

# Iterate over slide directories
declare -a missing=()
declare -a invalid=()

for slide_dir in "$SLIDES_ROOT"/slide-*/; do
  slide_name=$(basename "$slide_dir")
  mp4_file="${slide_dir}/${slide_name}-animation.mp4"
  if [[ ! -f "$mp4_file" ]]; then
    missing+=("$slide_name")
    continue
  fi
  
  # Check if file size is > 0
  if [[ ! -s "$mp4_file" ]]; then
    invalid+=("$slide_name (file is empty)")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Error: Missing animation MP4 files for slides: ${missing[*]}"
  exit 1
fi

if [[ ${#invalid[@]} -gt 0 ]]; then
  echo "Error: Invalid animation MP4 files (empty): ${invalid[*]}"
  exit 1
fi

echo "All animation MP4 files generated successfully."
exit 0
