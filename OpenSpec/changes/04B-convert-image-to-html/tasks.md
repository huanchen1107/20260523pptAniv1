# Tasks for `04-convert-image-to-html-using-hyperframe-excalidraw-skills`

## Goal
Convert each page image to an HTML file using HyperFrame and the Excalidraw‑control skill.

## Tasks
- [ ] **Create conversion script** `convert_images.sh` in `user/assets/` that:
  - Scans each `user/assets/slides/slide-*/` directory for an image file.
  - Uses the `excalidraw-control` skill to generate an Excalidraw scene for the image.
  - Calls `hyperframes render` to produce a responsive HTML file.
  - Writes the HTML output to `user/assets/slides/slide-<N>/slide-<N>.html`.
- [ ] **Make script executable** (`chmod +x convert_images.sh`).
- [ ] **Add README** in the change directory describing usage, prerequisites, and output location.
- [ ] **Add `hyperframes-cli` as a devDependency** via `npm i -D hyperframes-cli`.
- [ ] **Write unit/integration tests** in `tests/` to verify:
  - Successful conversion of a sample PNG.
  - Generated HTML is syntactically valid and renders correctly.
- [ ] **Run verification**:
  - Execute `bash convert_images.sh`.
  - Open a few generated HTML files in a browser to confirm visual fidelity.
- [ ] **Update CI pipeline** to run the conversion script as part of the asset‑preparation stage.
- [ ] **Commit changes** with a clear commit message.

## Verification Plan
- **Automated Tests**: Use the project’s test runner (`npm test` or `pytest`) to run the conversion on fixture images and compare the output against stored snapshots.
- **Manual Check**: Open generated HTML files in a browser and verify that the layout matches the source images.

## Open Questions
_None – all required information is captured in the `proposal.md` and `design.md` artifacts._
