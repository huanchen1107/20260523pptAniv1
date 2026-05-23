#!/usr/bin/env bash

# convert_images.sh
# Scan each slide folder for an image and generate HTML inside that folder as slide-N.html.

set -euo pipefail

BASE_SLIDE_DIR="$(pwd)/user/assets/slides"

mkdir -p "$BASE_SLIDE_DIR"

idx=1

process_slide() {
  local slide_dir="$1"
  local img_path=$(find "$slide_dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.svg" \) | head -n 1)
  if [[ -z "$img_path" ]]; then
    echo "No image found in $slide_dir, skipping."
    return
  fi
  echo "Processing $img_path -> $slide_dir/slide-${idx}.html"
  excalidraw_json=$(excalidraw-control generate "$img_path" 2>/dev/null || echo "{}")
  echo "$excalidraw_json" | hyperframes render --input-json -o "$slide_dir/slide-${idx}.html"
  ((idx++))
}

shopt -s nullglob
for slide_dir in "$BASE_SLIDE_DIR"/slide-*; do
  if [[ -d "$slide_dir" ]]; then
    process_slide "$slide_dir"
  fi
done

echo "Storyboard HTML generated for $((idx-1)) slide(s)."
