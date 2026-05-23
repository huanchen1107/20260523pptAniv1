#!/usr/bin/env bash
set -euo pipefail

# Directories
SLIDES_ROOT="user/assets/slides"

# Loop over each slide folder
for slide_dir in "$SLIDES_ROOT"/slide-*/; do
  slide_name=$(basename "$slide_dir")
  storyboard_file="${slide_dir}/${slide_name}-storyboard.html"
  slide_html_file="${slide_dir}/${slide_name}.html"
  audio_file="${slide_dir}/${slide_name}.mp3"
  output_mp4="${slide_dir}/${slide_name}-animation.mp4"

  # Ensure storyboard exists
  if [[ ! -f "$storyboard_file" ]]; then
    echo "Missing storyboard for $slide_name, skipping"
    continue
  fi

  # Use hyperframes render. If audio exists, include it via --audio flag
  if [[ -f "$audio_file" ]]; then
    npx hyperframes render "$slide_dir" -c "${slide_name}-storyboard.html" -o "$output_mp4" --audio "$audio_file"
  else
    npx hyperframes render "$slide_dir" -c "${slide_name}-storyboard.html" -o "$output_mp4"
  fi
  echo "Rendered animation $output_mp4"
done
