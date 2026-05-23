#!/usr/bin/env bash
set -euo pipefail

# Directory containing slide images (default: user/assets/slides)
SLIDES_DIR="${1:-user/assets/slides}"

# Loop over each slide directory (slide-*/)
for slide_dir in "$SLIDES_DIR"/slide-*/; do
  # Find first image file (png/jpg/jpeg/svg) in the directory
  img=$(find "$slide_dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.svg" \) | head -n 1)
  if [[ -z "$img" ]]; then
    echo "No image found in $slide_dir, skipping…"
    continue
  fi

  base=$(basename "$img")
  name="${base%.*}"  # strip extension

  # Generate Excalidraw scene JSON using the skill
  scene_json=$(excalidraw-control "$img")
  tmp_json="$slide_dir/${name}_scene.json"
  echo "$scene_json" > "$tmp_json"

  # Render HTML via HyperFrames
  out_html="$slide_dir/${name}.html"
  npx hyperframes render "$tmp_json" -o "$out_html"

  # Clean up temporary JSON
  rm -f "$tmp_json"
  echo "Generated $out_html"
done
