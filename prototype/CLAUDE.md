# prototype/ — Claude guidance

Astro prototype. Built once in Astro, then ported to WordPress. Every rule here exists so the port is a straight copy, not a rewrite.

## Rules

1. **Astro only.** No React/Vue/Svelte/Solid/Preact integrations — don't add them to `astro.config.mjs`.
2. **Design tokens only.** Every style must reference `var(--token)`. No raw colours, no magic numbers for spacing, no inline fonts.
3. **If a token is missing, add it to `design-system/` first** — then use it. Never hardcode "just for now".
4. **One Astro component = one future Elementor widget.** Build components the way you'd expose them as widgets: props in, markup out. Keep business logic out of templates where possible.
5. **Animations**: Three.js + GSAP only. Wire up in `src/scripts/`, import from components as needed. Respect `prefers-reduced-motion` (already handled in `animations.css`).
6. **No client-side framework state management.** If interactivity is needed, plain JS + GSAP. If it feels like it needs React, we're doing too much in the prototype.

## File layout

```
src/
├── styles/
│   └── global.css          # imports design-system CSS, sets base typography
├── layouts/
│   └── Base.astro          # <html>, Google Fonts, meta, slot
├── pages/
│   └── index.astro         # home page
├── components/             # one .astro per future widget (e.g. Hero.astro, FeatureCard.astro)
└── scripts/                # vanilla JS modules using Three.js / GSAP
```

## Dev

```bash
npm install
npm run dev          # http://localhost:4321
npm run build
npm run preview
```

## Deploy

Cloudflare Pages with git integration. On connect, set:
- **Build command:** `npm run build`
- **Build output directory:** `dist`
- **Root directory:** `prototype`

No wrangler.toml needed.

## Google Fonts

The `<link>` tag lives in `src/layouts/Base.astro`. When `--font-display` / `--font-body` change in `design-system/typography.css`, update the `<link>` to load the matching family.

## Porting later

When a component is ready to port to WP:
1. Open the `.astro` file. The markup inside `<div>...</div>` becomes the widget's render output (translated to PHP `echo` or templated HTML).
2. Props declared at the top become Elementor widget controls.
3. Scoped `<style>` goes into `wordpress-theme/assets/css/components/<name>.css` and is enqueued with the widget.
4. Any `src/scripts/*` used becomes enqueued JS on the widget.
