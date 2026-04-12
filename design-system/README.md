# Design system — {{CLIENT_NAME}}

Single source of truth for every visual decision. Change the token here, the whole site follows.

## Files

- **`tokens.css`** — colour, spacing, radius, shadow, z-index, breakpoint tokens.
- **`typography.css`** — font families, weights, fluid type scale, line heights.
- **`animations.css`** — durations and easings shared by CSS and GSAP.
- **`preview.html`** — visual overview. Open in a browser.

## How to use in Astro

In `prototype/src/styles/global.css`, the three files above are imported, then all components reference tokens via CSS custom properties:

```css
.button {
  background: var(--color-primary);
  padding: var(--space-3) var(--space-5);
  border-radius: var(--radius-pill);
  font-family: var(--font-body);
  font-size: var(--font-size-md);
  transition: background var(--duration-fast) var(--ease-standard);
}
.button:hover { background: var(--color-primary-hover); }
```

## How to use in GSAP

Animation tokens are readable from JS:

```js
const ds = getComputedStyle(document.documentElement);
gsap.to(el, {
  y: 0,
  duration: parseFloat(ds.getPropertyValue('--duration-base-s')),
  ease: 'power3.out', // matches --ease-emphasized
});
```

## Semantic vs. raw tokens

- **Raw tokens** (`--color-neutral-100`, `--color-brand-500`) — the underlying palette.
- **Semantic tokens** (`--color-bg`, `--color-text`, `--color-primary`) — how the raw tokens are used. **Always prefer semantic tokens in components.** Raw tokens exist to define semantic ones.

## Rules

1. If you need a value that isn't in a token, **add the token here first**, then use it.
2. Don't invent new semantic tokens that duplicate existing ones.
3. When any token changes, open `preview.html` to sanity-check, then copy the CSS files into `wordpress-theme/assets/css/` to keep WP in sync.

## Changelog

Record significant token changes here:

- `YYYY-MM-DD` — _e.g. Introduced `--color-accent` to support new CTA style after Round 2 feedback._
