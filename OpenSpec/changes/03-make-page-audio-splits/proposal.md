# Proposal for Change 03-make-page-audio-splits

**Goal:** Split the source video and its subtitle file into per‑page assets, placing each slide’s image, audio segment, and helper script into its own `slide‑N/` folder.

**Background:** The HyperFrame animation pipeline expects a one‑to‑one mapping between slides and media assets. Manually extracting these files is error‑prone and hampers reproducibility. Automating the split ensures a clean, repeatable workflow.

**Scope:**
- **Inputs**: `user/assets/source-video.mp4` and `user/assets/A2Zsrt.srt` (or any matching SRT).
- **Slide detection**: Use `ffmpeg` scene‑change detection (`gt(scene,0.4)`) to identify slide boundaries.
- **Per‑slide processing** for each detected slide `N`:
  1. Create folder `slide‑N/`.
  2. Export the first frame of the slide as `slide‑N.png` (starting at 00:01 for the first slide).
  3. Extract the corresponding audio segment as `audio‑N.mp3` using lossless `ffmpeg` cutting.
  4. Generate a `process_page.sh` script that runs the above steps for that page (useful for re‑processing).
- **Subtitle handling**: Skip any silent subtitle sections; only generate assets for slides that contain spoken content.
- **Naming**: All files use an `NN-` prefix matching the slide number (e.g., `01-slide-1.png`, `01-audio-1.mp3`).

**Success Criteria:**
- After executing `split_pages.sh`, a `slide‑N/` directory exists for every detected slide.
- Each `slide‑N/` folder contains `slide‑N.png`, `audio‑N.mp3`, and `process_page.sh`.
- No missing or mis‑aligned audio; file names follow the established numbering rule.
- The generated assets are consumable by downstream HyperFrame generation without further manual adjustment.
