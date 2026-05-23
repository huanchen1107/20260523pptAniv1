## Why

Automating the conversion of design images (PNG, JPEG, SVG) into responsive HTML pages eliminates the time‑consuming manual recreation of visual assets for web delivery. Designers can keep working with familiar raster formats while developers receive ready‑to‑use, interactive HTML components.

## Goal
Convert each page image to an HTML file using HyperFrame and the Excalidraw‑control skill.

## What Changes

- Add a new CLI script `convert_images.sh` that scans each `user/assets/slides/slide-*/` directory for an image, uses the `excalidraw‑control` skill to generate an Excalidraw scene, and renders HTML with HyperFrame into the same slide folder as `slide-<N>.html`.
- Introduce a new capability `image-to-html-conversion` that defines the contract for this conversion pipeline.
- Create supporting documentation (README, design, specs, tasks) for the new change.

## Capabilities

### New Capabilities
- `image-to-html-conversion`: Enables deterministic transformation of raster images into HyperFrame‑driven HTML pages using Excalidraw.

### Modified Capabilities
- *(none)*

## Impact

- Adds dependencies on `excalidraw‑control` (local skill) and `hyperframes-cli` (npm package).
- Extends the build pipeline to include an image‑to‑HTML generation step.
- Requires updates to CI scripts to run `convert_images.sh` during asset preparation.
