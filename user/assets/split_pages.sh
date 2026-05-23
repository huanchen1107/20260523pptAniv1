#!/usr/bin/env bash
# --------------------------------------------------------------
# split_pages.sh – Generate per‑slide assets from source video and PDF
# --------------------------------------------------------------
# Expected inputs (relative to project root):
#   user/assets/A2Z-original.mp4         – source video
#   user/assets/A2ZpdfExcalidraw.pdf      – PDF with slide pages
#   user/assets/A2Zsrt.srt                – subtitle file (captions only, retained for reference)
# Output: user/assets/slides/slide‑N/ folders each containing:
#   slide‑N.png   – rendered PDF page as PNG
#   audio‑N.mp3   – audio segment for that slide (extracted from video)
#   caption‑N.txt – generated caption via Whisper
#   process_page.sh – helper script to re‑run extraction for a single slide
# --------------------------------------------------------------

set -euo pipefail

# Paths
VIDEO="A2Z-original.mp4"
PDF="A2ZpdfExcalidraw.pdf"
SRT="A2Zsrt.srt"   # retained for caption reference, not used for timing
OUTPUT_DIR="slides"
TARGET_SLIDE="${1:-}"   # optional specific slide number

# --------------------------------------------------------------
# 1. Determine number of pages in the PDF
# --------------------------------------------------------------
if ! command -v pdfinfo > /dev/null; then
  echo "Error: pdfinfo (poppler-utils) is required but not installed." >&2
  exit 1
fi
PAGE_COUNT=$(pdfinfo "$PDF" | awk '/Pages:/ {print $2}')
if [[ -z "$PAGE_COUNT" ]]; then
  echo "Error: Unable to read page count from PDF." >&2
  exit 1
fi

# --------------------------------------------------------------
# 2. Detect slide boundaries in the video using ffmpeg scene change detection
# --------------------------------------------------------------
if ! command -v ffmpeg > /dev/null; then
  echo "Error: ffmpeg is required but not installed." >&2
  exit 1
fi
SCENES_FILE=$(mktemp)
ffmpeg -i "$VIDEO" -filter:v "select='gt(scene,0.4)',showinfo" -vsync vfr -f null - 2>&1 |
  grep -o "pts_time:[0-9.]*" | cut -d: -f2 > "$SCENES_FILE"
# Ensure first slide starts at 1.0 second as required
echo "1.0" >> "$SCENES_FILE"
sort -n -u "$SCENES_FILE" -o "$SCENES_FILE"

# Load scene timestamps into an array
timestamps=()
while IFS= read -r line; do
  timestamps+=("$line")
done < "$SCENES_FILE"
# Remove the initial placeholder (1.0) if present
if [[ "${timestamps[0]}" == "1.0" ]]; then
  timestamps=("${timestamps[@]:1}")
fi
# Use the lesser of PDF pages and detected timestamps
MAX_SLIDES=$(( PAGE_COUNT < ${#timestamps[@]} ? PAGE_COUNT : ${#timestamps[@]} ))

# --------------------------------------------------------------
# 3. Generate slide folders, assets, and captions
# --------------------------------------------------------------
mkdir -p "$OUTPUT_DIR"
slide_num=1
prev_time=1.0
while (( slide_num <= MAX_SLIDES )); do
  # Skip if a specific slide is requested
  if [[ -n "$TARGET_SLIDE" && "$slide_num" -ne "$TARGET_SLIDE" ]]; then
    prev_time=${timestamps[$((slide_num-1))]}
    ((slide_num++))
    continue
  fi

# Determine start and end times for this slide
start_time=$prev_time
end_time=${timestamps[$((slide_num-1))]}
# If no end timestamp (last slide), use video duration
if [[ -z "$end_time" ]]; then
  end_time=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO")
fi
# Ensure end_time is greater than start_time
if (( $(echo "$end_time <= $start_time" | bc -l) )); then
  end_time=$(printf "%.3f" "$(echo "$start_time + 0.5" | bc)")
fi
  PAGE_DIR="$OUTPUT_DIR/slide-$slide_num"
  mkdir -p "$PAGE_DIR"

  # ----- Render PDF page as PNG -----
  # pdftoppm creates files like slide-1.png; use -singlefile to avoid extra suffixes
  pdftoppm -f $slide_num -l $slide_num -png -r 300 "$PDF" "$PAGE_DIR/slide-$slide_num"

  # ----- Extract audio segment -----
  audio_file="$PAGE_DIR/audio-$slide_num.mp3"
  ffmpeg -y -i "$VIDEO" -ss "$start_time" -to "$end_time" -vn -c:a libmp3lame -q:a 2 "$audio_file" -loglevel error

  # ----- Generate caption using Whisper (assumes `whisper` CLI is available) -----
  caption_file="$PAGE_DIR/caption-$slide_num.txt"
  if command -v whisper > /dev/null; then
    whisper "$audio_file" --model tiny --output_dir "$PAGE_DIR" --output_format txt > /dev/null 2>&1
    # Whisper writes a file named <audio_file>.txt; rename to our convention
    mv "$PAGE_DIR/$(basename "$audio_file").txt" "$caption_file" || true
  else
    echo "# Whisper not installed – caption placeholder" > "$caption_file"
  fi

  # ----- Helper script for re‑processing this slide -----
  proc_script="$PAGE_DIR/process_page.sh"
  cat > "$proc_script" <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
VIDEO="user/assets/A2Z-original.mp4"
START="__START__"
END="__END__"
PAGE="__PAGE__"
OUTDIR="$(dirname "$0")"
# Re‑extract audio
ffmpeg -i "$VIDEO" -ss "$START" -to "$END" -c:a copy -vn "$OUTDIR/audio-$(basename "$OUTDIR").mp3" -loglevel error
# Re‑render PDF page
pdftoppm -f $PAGE -l $PAGE -png -r 300 "user/assets/A2ZpdfExcalidraw.pdf" "$OUTDIR/slide-$(basename "$OUTDIR")"
# Regenerate caption if Whisper is available
if command -v whisper > /dev/null; then
  whisper "$OUTDIR/audio-$(basename "$OUTDIR").mp3" --model tiny --output_dir "$OUTDIR" --output_format txt > /dev/null 2>&1
  mv "$OUTDIR/$(basename "$OUTDIR").mp3.txt" "$OUTDIR/caption-$(basename "$OUTDIR").txt" || true
fi
EOS
  chmod +x "$proc_script"
  # Replace placeholders
  sed -i '' "s|__START__|$start_time|" "$proc_script"
  sed -i '' "s|__END__|$end_time|" "$proc_script"
  sed -i '' "s|__PAGE__|$slide_num|" "$proc_script"

  ((slide_num++))
  prev_time=$end_time
done

# Clean up temporary file
rm "$SCENES_FILE"

echo "✅ Generated $((slide_num-1)) slide folders under $OUTPUT_DIR"
