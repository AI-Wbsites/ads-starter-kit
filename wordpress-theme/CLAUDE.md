# wordpress-theme/ — Claude guidance

Standalone WordPress theme that also bundles the site's custom Elementor widgets under a single custom category. Author is always **Amila Upathissa**, URI **https://amila.info**.

## Rules

1. **Standalone theme** — not a child theme. No parent dependency.
2. **Latest PHP.** Minimum PHP 8.2; write for the newest stable. Prefer modern syntax: enums, readonly properties/classes, first-class callable syntax, named arguments, typed class constants (PHP 8.3), strict return types on methods.
3. **Port from `prototype/` 1:1.** Same markup structure, same class names, same tokens. Visual parity is the goal.
4. **Design tokens are the source of truth.** `assets/css/tokens.css`, `typography.css`, `animations.css` must be byte-identical copies of the files in `design-system/`. When tokens change, re-copy — don't edit these in place.
5. **Every custom widget lives under the project's custom category** (slug `{{WIDGET_CATEGORY_SLUG}}`, label `{{WIDGET_CATEGORY_NAME}}`). No widgets should appear under "General" or other default categories.
6. **Widgets are added ONE AT A TIME — never in bulk.** This is a **workflow discipline**: build one widget, test it in Elementor, commit, then start the next. The loader itself is automatic — filename convention does the wiring, no `functions.php` edits needed per widget.
7. **Props become controls.** Anything that was an Astro prop becomes an Elementor control (text, textarea, URL, image, select, switcher). Expose the same inputs the prototype exposes.
8. **Text domain** is `{{THEME_TEXT_DOMAIN}}` everywhere — never hardcode a different string.

## Theme header

`style.css` starts with the theme header block. Keep these exact values:

```
Theme Name:   {{THEME_NAME}}
Theme URI:    {{SITE_URL}}
Author:       Amila Upathissa
Author URI:   https://amila.info
Text Domain:  {{THEME_TEXT_DOMAIN}}
Requires PHP: 8.2          (minimum — target newest stable)
```

## File layout

```
style.css                     Theme header + entry stylesheet
functions.php                 Theme bootstrap: supports, enqueues, module registration
index.php                     Minimal fallback template
header.php / footer.php       Basic structural templates
woocommerce/                  WooCommerce template overrides (create files when needed)
assets/
├── css/
│   ├── tokens.css            Copy of design-system/tokens.css
│   ├── typography.css        Copy of design-system/typography.css
│   ├── animations.css        Copy of design-system/animations.css
│   └── theme.css             Global styles (same rules as prototype/global.css)
└── js/
    └── motion.js             Copy / port of prototype/src/scripts/motion.js
inc/
├── post-types/
│   ├── post-type.template.php       Template — copy, rename, then register in functions.php
│   └── <slug>.php                   One file per CPT
├── taxonomies/
│   ├── taxonomy.template.php        Template
│   └── <slug>.php                   One file per taxonomy
├── fields/
│   ├── README.md                    Approach guide: native / ACF / CMB2 / Meta Box
│   └── <post-type-slug>-fields.php  One file per post type's fields
└── elementor/
    ├── class-widget-category.php    Registers {{WIDGET_CATEGORY_SLUG}}
    ├── widget.template.php          Template — NOT loaded; copy into widgets/ to create
    └── widgets/                     One file per Elementor widget (added one at a time)
```

## Adding a new post type / taxonomy / field group

1. Copy the matching `*.template.php` to a new file named after your slug (e.g. `project.php`). Files with `.template.` in the name are skipped by the loader.
2. Rename symbols (post type key, slug, labels).
3. Save. Auto-loaded — no `functions.php` edit needed.
4. Test in WP admin before moving to the next one.

## Adding a new Elementor widget

1. Build and approve the component in `prototype/`.
2. Copy `inc/elementor/widget.template.php` to `inc/elementor/widgets/class-<slug>-widget.php`.
3. Rename the class to `<Slug>_Widget` (PascalCase parts, separated by `_`) inside namespace `{{THEME_NAME}}\Widgets`. Update `get_name()`, `get_title()`, controls, and render.
4. Save. Auto-loaded and auto-registered by filename convention — no `functions.php` edit needed.
5. Add widget-specific CSS under `assets/css/components/<slug>.css`; enqueue it from the widget class if needed.
6. **Test the widget standalone in Elementor before starting the next one.** This is the rule that matters — the loader is automatic; the workflow discipline is manual.

**Filename → class name examples:**

| File                              | Class                                             |
|-----------------------------------|---------------------------------------------------|
| `class-hero-widget.php`           | `\{{THEME_NAME}}\Widgets\Hero_Widget`             |
| `class-feature-card-widget.php`   | `\{{THEME_NAME}}\Widgets\Feature_Card_Widget`     |
| `class-cta-banner-widget.php`     | `\{{THEME_NAME}}\Widgets\Cta_Banner_Widget`       |

## WooCommerce

Declared via `add_theme_support( 'woocommerce' )` plus product gallery features in `functions.php` — harmless if WC isn't active. When the project uses WooCommerce, copy the plugin's template files into `woocommerce/` and restyle with design-system tokens. See `woocommerce/README.md`.

## Syncing tokens from the design system

From the repo root:

```bash
cp design-system/tokens.css      wordpress-theme/assets/css/tokens.css
cp design-system/typography.css  wordpress-theme/assets/css/typography.css
cp design-system/animations.css  wordpress-theme/assets/css/animations.css
```

Run this after any token change. Don't hand-edit the copies.
