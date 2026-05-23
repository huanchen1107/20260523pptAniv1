#!/usr/bin/env bash
set -euo pipefail
VIDEO="user/assets/A2Z-original.mp4"
START="34.52"
END="61.72"
PAGE="4"
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
