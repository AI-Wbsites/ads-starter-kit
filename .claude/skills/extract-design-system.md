---
name: extract-design-system
description: Reverse-engineer a design system from a reference HTML/CSS website in reference/, then rebuild it as an Astro prototype that uses only design tokens.
---

## When to use

Invoke this when Amila has dropped an existing HTML/CSS website into `reference/` and asks to produce the design system and Astro prototype based on it. Typical prompts: "extract the design system from this site", "rebuild this in Astro", "turn this HTML into our prototype".

## Do not use for

- Client Q&A / business info — that workflow uses `info/`, not `reference/`.
- Building from scratch without a reference — that path starts from `info/` and fills `design-system/` by hand.

## Before starting

1. Run `ls reference/` — confirm there's at least one subfolder with HTML.
2. If there are **multiple** reference sites, ask Amila which one is the source of truth. Do not merge two systems without explicit instruction.
3. Scan `design-system/tokens.css` — if values have already been customised (not the starter defaults), confirm with Amila whether to replace or augment. Never silently overwrite a populated design system.

## Process

### 1. Inventory the reference

- List every `.html` file and every `.css` file under the chosen reference subfolder.
- Open each HTML file; write a one-line note of every distinct visible section (hero, nav, feature grid, pricing, footer, etc.).
- Open each CSS file; note which selectors/classes are used where.
- Capture `<style>` blocks and inline `style=""` attributes too.

### 2. Extract tokens

Scan every stylesheet source (external `.css`, `<style>` blocks, inline `style`) and cluster values:

| Category | What to extract | Where it goes |
|----------|-----------------|---------------|
| **Colours** | Every hex / rgb / hsl / named colour. Cluster similar shades; separate brand/accent from neutrals; name semantics (`--color-bg`, `--color-text`, `--color-primary`, `--color-accent`, `--color-border`). | `design-system/tokens.css` |
| **Font families** | Every `font-family` stack. Identify display vs body vs mono. | `design-system/typography.css` |
| **Font sizes** | Every `px` / `rem` / `em` size. Group into a scale `xs` → `5xl`. Prefer `clamp()` if a size spans responsive ranges. | `design-system/typography.css` |
| **Weights, line heights, letter spacing** | Collect all unique values; name them. | `design-system/typography.css` |
| **Spacing** | Every `margin`/`padding`/`gap`/`top`/`left` value. Normalise to a 4 px-based scale. | `design-system/tokens.css` (`--space-*`) |
| **Radii** | Every `border-radius` value. Cluster to `xs/sm/md/lg/pill`. | `design-system/tokens.css` |
| **Shadows** | Every `box-shadow`. Cluster to `sm/md/lg`. | `design-system/tokens.css` |
| **Motion** | Every `transition-duration` / `animation-duration` / timing function. Cluster to `instant/fast/base/slow/slower` and `standard/out/in/emphasized/spring`. | `design-system/animations.css` |
| **Breakpoints** | Every `@media` threshold. | `design-system/tokens.css` (`--bp-*`) |
| **Z-index** | Every explicit `z-index`. Cluster to `base/nav/modal/toast`. | `design-system/tokens.css` |

Keep raw palette tokens (e.g. `--color-brand-500`) and define semantic tokens on top (e.g. `--color-primary: var(--color-brand-500)`). Components will use semantic tokens only.

### 3. Write the design system

**Augment, do not wholesale-replace.** Keep the file structure and naming. Preserve any tokens already in place unless explicitly told to replace them. Edit the three files:

- `design-system/tokens.css`
- `design-system/typography.css`
- `design-system/animations.css`

Append a line to `design-system/README.md`'s changelog:

```
- YYYY-MM-DD — Tokens extracted from reference/<folder-name>.
```

### 4. Sync WordPress theme token mirrors

Copy the three updated files into `wordpress-theme/assets/css/` (byte-identical):

```bash
cp design-system/tokens.css      wordpress-theme/assets/css/tokens.css
cp design-system/typography.css  wordpress-theme/assets/css/typography.css
cp design-system/animations.css  wordpress-theme/assets/css/animations.css
```

### 5. Update the fonts loader

If `--font-display` or `--font-body` changed, update the Google Fonts `<link>` in `prototype/src/layouts/Base.astro` (and in `wordpress-theme/functions.php`'s font enqueue) to load the matching family and weights.

### 6. Rebuild each component in Astro

For every distinct visible section in the reference:

1. Create `prototype/src/components/<PascalName>.astro`.
2. Translate the markup — preserve semantic structure (use the same headings, landmarks, aria attributes).
3. **Replace every hardcoded value with `var(--token)`.** No hex, no raw px for type/spacing, no named easing curves inline.
4. Expose props for every value a future Elementor widget should expose (headings, body text, URLs, image sources, CTA labels, boolean toggles).
5. Scoped `<style>` is fine; only use tokens inside it.

### 7. Rebuild pages

For each page in the reference, create the matching `.astro` page under `prototype/src/pages/` and compose it from the new components.

### 8. Motion pass

Look at how the reference animates (scroll reveals, hovers, hero motion). Re-implement with GSAP + Three.js where warranted, using duration/ease tokens — do not copy raw `cubic-bezier()` strings into the new code.

### 9. Verify

- Run `cd prototype && npm install && npm run dev`. Open each rebuilt page; compare visually with the reference.
- Grep the prototype for raw values that shouldn't be there:
  ```bash
  grep -rEn '#[0-9a-fA-F]{3,8}|rgb\(|\b[0-9]+px\b' prototype/src
  ```
  Exceptions: `0px`, values inside imported vendor files. Everything else should resolve to a token.
- Open `design-system/preview.html` — every token on the page should match how the prototype looks.

### 10. Report back

When finished, give Amila a short report:

- Tokens added or changed (grouped by category, count + key names).
- Components created (name + source section).
- Pages rebuilt.
- Any reference values you couldn't cleanly map (list them; ask how to handle).
- Anything in the reference that looked intentional but unusual (one-off colour, decorative font) that might be worth preserving verbatim — call it out rather than normalising it silently.
