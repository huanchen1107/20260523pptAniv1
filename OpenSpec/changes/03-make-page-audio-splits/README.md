# Make Page Audio Splits & Slide Packages

## Overview
This change introduces a workflow that converts the extracted video and subtitle assets into per‑page packages suitable for Chinese PPT animation.

- **Audio files**: `audio‑N.mp3` (starting at 1) – generated from `A2Z-original-audio.mp3`.
- **Slide images**: `slide‑N.png` – captured at the beginning of each slide.
- **Page folder**: `slide‑N/` containing the audio, image, and a tiny helper script.
- **Slide‑1 start time** is forced to **00:01** (1 second) as specified.
- Silent subtitle entries are **skipped**.

The assets live under `user/assets/` and the change is documented in OpenSpec.
