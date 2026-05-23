## Context

The repository has been updated with the global `hyperframes` CLI and custom agent skills for both HyperFrames and Excalidraw control. We must establish a system check to verify that all configurations and CLI validations compile and run seamlessly.

## Goals / Non-Goals

**Goals:**
* Verify syntax cleanliness for `hyperframes-best-practices` and `excalidraw-control` agent skills.
* Validate that OpenSpec's newly modified validator correctly resolves numeric prefixes.

**Non-Goals:**
* Rebuilding external dependencies beyond local tests.

## Decisions

* **Decision: Use local linked OpenSpec CLI for validation**
  * **Alternative:** Running global un-linked packages.
  * **Rationale:** Local linking guarantees that the updated regex in `change-utils.ts` is verified in practice.

## Risks / Trade-offs

* **Risk:** CLI configuration overrides on other machines.
  * **Mitigation:** Ensure linked state is documented in startup and ending procedures.
