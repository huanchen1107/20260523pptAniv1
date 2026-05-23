# Proposal for `05-make-storyboard-for-each-page`

## Overview
We will generate a **storyboard HTML** for each slide (`slide‑<N>-storyboard.html`). The storyboard defines object visibility, easing, and camera pan/zoom based on the slide caption semantics.

## Key Features
- **GSAP** animation library for rich, deterministic timelines.
- **HyperFrames** rendering engine (`npx hyperframes render`) to produce high‑fidelity MP4 videos.
- Automatic generation script (`user/assets/generate_storyboard.sh`).
- Manual GitHub Actions workflow (`.github/workflows/storyboard.yml`) that can also render videos on demand.
- Integration test (`tests/storyboard.test.sh`) to ensure every storyboard file is created and contains the required `data‑hf‑*` attributes.

## Acceptance Criteria
- Running `./user/assets/generate_storyboard.sh` creates `slide‑<N>-storyboard.html` for every slide in `user/assets/slides/`.
- Storyboard HTML includes GSAP timeline that fades in captions, zooms in/out when the caption contains keywords like "zoom in" or "focus".
- Optional CI step renders each storyboard to MP4 when the workflow input `render` is set to `true`.
- All tests pass.
