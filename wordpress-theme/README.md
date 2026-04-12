# {{THEME_NAME}} WordPress theme

Custom theme for {{CLIENT_NAME}}. Bundles all custom Elementor widgets under the **{{WIDGET_CATEGORY_NAME}}** category.

- **Author:** Amila Upathissa — https://amila.info
- **Text domain:** `{{THEME_TEXT_DOMAIN}}`
- **Requires:** WordPress 6.0+, PHP 7.4+, Elementor

## Install

Copy (or symlink) this folder into `wp-content/themes/{{THEME_SLUG}}` and activate it in WP admin.

## Design tokens

Tokens are mirrored from `../design-system/` into `assets/css/`. When tokens change, re-copy — don't hand-edit these:

```bash
cp ../design-system/tokens.css      assets/css/tokens.css
cp ../design-system/typography.css  assets/css/typography.css
cp ../design-system/animations.css  assets/css/animations.css
```

## Widgets

Each widget lives in `inc/elementor/widgets/class-<name>.php` and is auto-loaded by `functions.php`. Register each widget in the `elementor/widgets/register` hook.

See `CLAUDE.md` for authoring rules.
