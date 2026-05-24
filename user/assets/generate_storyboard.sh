#!/usr/bin/env bash
set -euo pipefail

# Directories
SLIDES_ROOT="user/assets/slides"
# # OUTPUT_DIR not needed; storyboard will be placed inside each slide folder
# No output directory needed

# Load default config (frame rate, duration, etc.)
FRAME_RATE=30
SLIDE_DURATION_FRAMES=150  # 5 seconds at 30fps

# Function to decide zoom factor from caption
function determine_zoom() {
  local caption="$1"
  if [[ "$caption" =~ "zoom in" ]] || [[ "$caption" =~ "focus" ]]; then
    echo "2"  # 2x zoom
  else
    echo "1"
  fi
}

for slide_dir in "$SLIDES_ROOT"/slide-*/; do
  slide_name=$(basename "$slide_dir")
  # Find the generated slide HTML (fallback name) and source image
  html_file=$(find "$slide_dir" -maxdepth 1 -name "${slide_name}.html" -print -quit)
  img_file=$(find "$slide_dir" -maxdepth 1 \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.svg" \) | head -n1)
  caption_file="${slide_dir}/caption-${slide_name}.txt"
  caption=""
  if [[ -f "$caption_file" ]]; then
    caption=$(cat "$caption_file")
  fi
  zoom=$(determine_zoom "$caption")

  storyboard_file="${slide_dir}/${slide_name}-storyboard.html"

  audio_tag=""
  if [[ -f "${slide_dir}/${slide_name}.mp3" ]]; then
    # We can just use the slide duration for the audio duration limit
    duration_secs=$((SLIDE_DURATION_FRAMES / FRAME_RATE))
    audio_tag="<audio id=\"slide-audio\" src=\"${slide_name}.mp3\" data-start=\"0\" data-duration=\"${duration_secs}\" data-track-index=\"0\" data-volume=\"1\"></audio>"
  fi

  cat > "$storyboard_file" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${slide_name} Storyboard</title>
  <script src="https://cdn.jsdelivr.net/npm/gsap@3.12.5/dist/gsap.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@hyperframes/cli"></script>
  <style>
    body,html{margin:0;padding:0;overflow:hidden;background:#111;}
    #stage{position:relative;width:1080px;height:1920px;margin:0 auto;}
    img{position:absolute;top:0;left:0;width:100%;height:100%;object-fit:contain;}
    .caption{position:absolute;bottom:5%;width:100%;text-align:center;color:#fff;font-size:2rem;opacity:0;}
  </style>
</head>
<body data-hf-timeline="${slide_name}" data-hf-duration="${SLIDE_DURATION_FRAMES}" data-hf-fps="${FRAME_RATE}">
  <div id="stage" data-composition-id="${slide_name}" data-width="1080" data-height="1920">
    <img id="slideImg" src="$(basename "$img_file")" alt="${slide_name}">
    ${caption:+<div class="caption" id="caption">${caption}</div>}
    ${audio_tag}
  </div>
  <script>
    const tl = gsap.timeline({paused:true});
    // fade‑in caption if present
    if (document.getElementById('caption')) {
      tl.to('#caption', {duration:1, opacity:1, ease:'power2.out'}, 0);
    }
    // zoom animation based on caption keyword
    const zoomFactor = ${zoom};
    if (zoomFactor > 1) {
      tl.to('#slideImg', {duration:2, scale:zoomFactor, ease:'power2.inOut'}, 0);
      tl.to('#slideImg', {duration:2, scale:1, ease:'power2.inOut'}, 2);
    }
    
    // Hyperframes v2 integration
    window.__timelines = window.__timelines || {};
    window.__timelines["${slide_name}"] = tl;
    window.__hf = {
      duration: ${SLIDE_DURATION_FRAMES} / ${FRAME_RATE},
      seek: (time) => { tl.seek(time); }
    };
    
    window.addEventListener("hyperframes-tick", (event) => {
      const targetTime = event.detail.frame / event.detail.fps;
      tl.seek(targetTime);
    });
  </script>
</body>
</html>
EOF
  echo "Generated storyboard $storyboard_file"
  # Render to video (optional, CI will do this)
  # npx hyperframes render "$storyboard_file" -o "${storyboard_file%.html}.mp4"

done
