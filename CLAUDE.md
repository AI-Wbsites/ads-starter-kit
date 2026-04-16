# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A **starter template** for Amila Upathissa's web design workflow. Clone it per client. Every client project follows the same phases:

1. **Info gathering** — client fills/answers the questionnaire; replies land in `info/` in whatever form they arrive (email, voice notes, chat). If the client supplies a reference HTML site, drop it in `reference/` — the `extract-design-system` skill (`.claude/skills/`) handles extraction + rebuild.
2. **Design system** — tokens (colors, type, spacing, motion) are defined/updated in `design-system/` **before** any design work. When a reference site exists, tokens are extracted from it first.
3. **Prototype** — Astro site built in `prototype/` using only design-system tokens. No React/Vue/Svelte. Three.js + GSAP allowed for animation.
4. **Review** — prototype deployed via Cloudflare Pages (git integration). Link goes to client. Iterate on feedback logged in `info/feedback.md`.
5. **WordPress theme** — when prototype is approved, port 1:1 into `wordpress-theme/`. Standalone theme, author **Amila Upathissa**, URI **https://amila.info**. Targets the **latest stable PHP** (min 8.2). Includes CPTs, taxonomies, custom fields, and WooCommerce layouts when the project needs them.
6. **Elementor widgets** — one widget per Astro component, bundled inside the theme under a custom widget category (name set per project). **Widgets are added one at a time** after the theme is created — never in bulk. Each widget is explicitly registered.
7. **Publish** — launch the WordPress site.

## Non-negotiable rules

### Design-system-first
- **Never hardcode** a color, font, size, spacing, radius, shadow, duration, or easing anywhere in the codebase. Use tokens (`var(--token-name)`) only.
- If a design change needs a value that isn't in the system, **update `design-system/` first**, then use the new token. No exceptions.
- One token file is the source of truth. The WordPress theme pulls a copy — they must stay in sync.

### No other JS frameworks in the prototype
- Astro only. **No React, Vue, Svelte, Solid, Preact integrations.**
- Reason: every Astro component will later be ported to a PHP-rendered Elementor widget. Framework components don't port.
- Allowed libraries: **Three.js**, **GSAP**, and small vanilla utilities.

### Port fidelity
- WordPress components must match the Astro prototype 1:1 — same markup structure, same class names, same tokens.
- Elementor widget controls should expose the same props the Astro component accepts.

## Workflow commands (common)

```bash
# Prototype
cd prototype && npm install
cd prototype && npm run dev          # local dev server
cd prototype && npm run build        # production build (Cloudflare Pages runs this)
cd prototype && npm run preview      # preview the build

# WordPress theme — no build step by default
# Activate by symlinking/copying wordpress-theme/ into wp-content/themes/
```

## Per-project placeholders

When a new project is cloned, search for and replace these across the repo:

| Placeholder                     | Example                        |
|---------------------------------|--------------------------------|
| `{{CLIENT_NAME}}`               | "Acme Corp"                    |
| `{{THEME_SLUG}}`                | "acme"                         |
| `{{THEME_NAME}}`                | "Acme"                         |
| `{{THEME_TEXT_DOMAIN}}`         | "acme"                         |
| `{{THEME_CONST_PREFIX}}`        | "ACME" (uppercase of slug)     |
| `{{WIDGET_CATEGORY_SLUG}}`      | "acme-widgets"                 |
| `{{WIDGET_CATEGORY_NAME}}`      | "Acme Widgets"                 |
| `{{SITE_URL}}`                  | "https://acme.com"             |

Run `./init.sh` from the repo root to prompt for these and stamp the repo in one go.

Theme author is always **Amila Upathissa**, URI **https://amila.info** — never change those.

## Sync to a live WordPress install

`tool/sync-wordpress.sh` watches `wordpress-theme/` with `inotifywait` and mirrors it to the destination in `tool/.sync-dest` via `rsync --delete`. The destination is captured by `init.sh` (blank skips it) and can be edited later by hand.

When Amila says **"sync wordpress dir"** (or similar), run `./tool/sync-wordpress.sh` in the foreground — it's a long-running watcher, not a one-shot.

## Folder-specific guidance

Each top-level folder has its own `CLAUDE.md` with scope-specific rules:

- `info/CLAUDE.md` — what to read before building anything
- `design-system/CLAUDE.md` — token authoring rules
- `prototype/CLAUDE.md` — Astro conventions + animation rules
- `wordpress-theme/CLAUDE.md` — theme + widget authoring rules

**Read the folder's CLAUDE.md before editing files inside it.**

## What matters most

**The prototype is the product during review.** The WordPress port is a mechanical translation that comes later — the only creative decisions happen in `prototype/` (informed by `info/` and constrained by `design-system/`). Spend the craft budget there: polished animations, clean motion, taste in layout and spacing. The theme and widgets should reproduce it, not reinvent it.

## Claude Code config (`.claude/`)

- `settings.local.json` — `defaultMode: bypassPermissions` so Amila isn't prompted to approve each tool call inside a project.
- `skills/` — project-scoped skills (add as the need arises, not speculatively).
- `commands/` — custom slash commands (same rule).

See `.claude/README.md`.
