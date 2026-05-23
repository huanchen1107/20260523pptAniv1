# Tasks – Make Page Audio Splits & Slide Packages

- [x] **Create script** `split_pages.sh` in `user/assets/` that:
  - Parses `A2Zsrt.srt` for timestamps and text.
  - Detects slide transitions via `ffmpeg` scene‑change detection.
  - Forces first slide start at 00:01.
  - Skips silent subtitle entries.
  - Generates `slide‑N/` folders with `audio‑N.mp3`, `slide‑N.png`, and `process_page.sh`.
- [x] **Make script executable** (`chmod +x split_pages.sh`).
- [ ] **Add README** `OpenSpec/changes/03-make-page-audio-splits/README.md` describing usage and folder layout.
- [ ] **Add proposal** `OpenSpec/changes/03-make-page-audio-splits/proposal.md` (already contains detailed design and verification plan).
- [ ] **Add design** `OpenSpec/changes/03-make-page-audio-splits/design.md` (technical blueprint).
- [ ] **Update documentation** `user/assets/source-config.md` with a new "Audio‑Slide Split" tool section and usage example.
- [ ] **Run verification**:
  - Execute `bash split_pages.sh`.
  - Verify number of generated `audio‑N.mp3` files matches non‑empty subtitles.
  - Spot‑check durations with `ffprobe`.
  - Confirm `slide‑1.png` extracted near 00:01.
- [ ] **Commit changes** to the repository.
