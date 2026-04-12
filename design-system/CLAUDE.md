# design-system/ — Claude guidance

**This folder is the single source of truth for every design decision.** Change once here → whole site follows.

## Absolute rules

1. **No hardcoded values in the codebase.** Colors, fonts, sizes, spacing, radii, shadows, durations, easings — all referenced as `var(--token)`.
2. **Add tokens before using them.** If a component needs a value that isn't in the system, add the token here first, then use it.
3. **Don't alias existing tokens for no reason.** If `--color-primary` already exists, use it — don't create `--color-brand-main` pointing to the same thing.
4. **Keep tokens semantic where possible.** Prefer `--color-surface` over `--color-white-2`. Raw values (e.g. `--color-neutral-100`) exist to build semantic tokens on top of.
5. **Mirror this folder into the WordPress theme.** When tokens change, copy `tokens.css`, `typography.css`, `animations.css` into `wordpress-theme/assets/css/`. They must stay byte-identical across both.

## Files

- `tokens.css` — all tokens defined on `:root`. Colours, spacing, radii, shadows, z-index, breakpoints.
- `typography.css` — font families (Google Fonts), type scale, weights, line heights.
- `animations.css` — durations, easing curves shared by CSS transitions and GSAP.
- `preview.html` — open in a browser to eyeball every token at a glance.
- `README.md` — the living doc: what each token means and when to reach for it.

## Workflow when a token changes

1. Update `tokens.css` (and/or typography/animations) here.
2. Update `README.md` if the meaning or intent changed.
3. Rebuild the prototype — verify nothing looks broken: `cd prototype && npm run dev`.
4. Open `design-system/preview.html` to sanity-check tokens in isolation.
5. If the WP theme exists, copy the updated CSS files into `wordpress-theme/assets/css/` so they stay in sync.
6. Note the change in `info/feedback.md` if it was triggered by client feedback.
