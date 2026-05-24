# 06-create-page-animation

This change introduces the animation rendering pipeline for each slide using `hyperframes`.

## Changes made
- **`user/assets/render_animation.sh`**: Modified to rename the storyboard file to `index.html` temporarily during rendering to satisfy the `hyperframes render` requirement. It integrates audio into the MP4 if an audio file exists.
- **`storyboard.yml`**: Removed the optional rendering step to keep the `storyboard.yml` workflow strictly for generating storyboard HTML files. Fixed the artifact upload path.
- **`render_animation.yml`**: Created a new GitHub Actions workflow specifically triggered after `storyboard.yml` completes, which generates storyboards and then renders the animations to `.mp4`.
- **`tests/render_animation.test.sh`**: Added integration test to ensure all `.mp4` animation files are generated and are not empty. Fixed paths in `tests/storyboard.test.sh`.

## Verification
You can run `tests/render_animation.test.sh` locally to generate and verify all animations for all slides.
