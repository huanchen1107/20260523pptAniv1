## Why

Perform a complete project verification and system check to guarantee that the newly installed HyperFrames package, the Excalidraw diagram control skill, and the OpenSpec automation frameworks are fully integrated and operating correctly together in this workspace.

## What Changes

* **Skill Verification:** Validate that all custom agent skills (`hyperframes-best-practices` and `excalidraw-control`) are properly structured and syntactically clean.
* **CLI Sync:** Run automated CLI health checks to ensure OpenSpec registers the system profiles properly.
* **Scaffolding Checks:** Verify the creation of number-prefixed OpenSpec changes (`01-system-check`) under the modified validate rules.

## Capabilities

### New Capabilities
- `system-check`: A system validation suite to check workspace environments, verify compiler and runtime versions, and confirm agent skill directories are healthy.

### Modified Capabilities
<!-- None -->

## Impact

* **OpenSpec Validation:** Utilizes local linked OpenSpec commands.
* **Startup Flow:** Integrates step checks inside startup.sh.
