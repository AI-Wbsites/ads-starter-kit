# Amila Digital Solutions — web design starter

Starter template for a prototype-first WordPress workflow: Astro prototype → client review → WordPress theme with bundled Elementor widgets.

**Author:** Amila Upathissa — https://amila.info

## How to start a new client project

```bash
git clone <this-repo> client-name
cd client-name
```

Then:

1. Open `info/questionnaire.md`, send it to the client.
2. As replies come in, drop them into the relevant `info/*.md` files (or raw into `info/notes/`).
3. Fill in `design-system/tokens.css` with the client's palette, type, and scales.
4. Build in `prototype/` using only tokens. Deploy to Cloudflare Pages by connecting the repo.
5. Once the prototype is approved, port into `wordpress-theme/`.

## Non-negotiable rules

- Design tokens are the source of truth — no hardcoded colors, fonts, or sizes anywhere.
- Prototype uses Astro only — no React/Vue/Svelte. Three.js and GSAP allowed.
- WordPress theme is standalone (not a child theme). Author: **Amila Upathissa**.
- Elementor widgets live **inside** the theme under a custom category.

See `CLAUDE.md` for the full workflow and AI agent instructions.

## Folder layout

```
info/              Client-supplied info — read this first
design-system/     Tokens: colors, type, spacing, motion — source of truth
prototype/         Astro prototype site
wordpress-theme/   Standalone WP theme + bundled Elementor widgets
```
