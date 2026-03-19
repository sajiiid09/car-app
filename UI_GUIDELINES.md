# OnlyCars UI Guidelines

## Source of Truth

- `packages/oc_ui` is the current UI source of truth.
- Shared tokens, theme, and reusable widgets should be added there when the pattern is cross-app.
- App-local styling is acceptable only when the screen is truly app-specific and the shared system cannot express it yet.

## Frozen UI Direction for Stabilization

- Preserve the current Arabic-first approach.
- Preserve the current light-first visual system in `oc_ui`.
- Do not start an advanced design refresh in stabilization phases.
- Do not rebuild screens just to make them look newer.

## Rules

- Prefer `OcTheme`, `OcColors`, `OcSpacing`, `OcRadius`, and shared widgets before writing screen-local replacements.
- Do not introduce new app-local token files unless the need is documented and temporary.
- Do not fork the same widget pattern in multiple apps.
- Avoid one-off colors, spacing values, and custom cards/buttons that bypass `oc_ui` without a clear reason.
- If a screen must diverge from `oc_ui`, document the exception in the PR or follow-up cleanup note.

## What Counts as Out of Scope in Phase 1

- New branding direction
- New typography system
- New information architecture for admin dashboards
- Motion/animation refresh
- AI-assisted UX or diagnosis UI experiments

## Cleanup Direction After Phase 1

- Keep `oc_ui` as the single design-system package.
- Split oversized shared widget files only when a dedicated cleanup phase handles that package.
- Consumer should remain the reference implementation for shared UI usage.
