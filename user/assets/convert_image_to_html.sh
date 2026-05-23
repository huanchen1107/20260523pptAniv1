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

  # Generate Excalidraw scene JSON using the skill if available, else fallback
  if command -v excalidraw-control >/dev/null 2>&1; then
    scene_json=$(excalidraw-control "$img")
    tmp_json="$slide_dir/${name}_scene.json"
    echo "$scene_json" > "$tmp_json"
    # Render HTML via HyperFrames
    out_html="$slide_dir/$(basename "$slide_dir").html"
    npx hyperframes render "$tmp_json" -o "$out_html"
    rm -f "$tmp_json"
  else
    # Simple fallback: create basic HTML with the image
    out_html="$slide_dir/$(basename "$slide_dir").html"
    cat > "$out_html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>${name}</title></head>
<body style="margin:0;display:flex;justify-content:center;align-items:center;height:100vh;background:#f0f0f0;">
  <img src="$(basename "$img")" alt="${name}" style="max-width:100%;max-height:100%;" />
</body>
</html>
EOF
    echo "Generated fallback $out_html"
  fi
done
