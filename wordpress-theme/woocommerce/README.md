# WooCommerce template overrides

Only create files in this folder when the project needs WooCommerce.

## How overrides work

WooCommerce looks here **before** its own plugin templates. Copy the file you want to customise from the plugin into the matching path under this folder, then edit.

Common overrides:

```
woocommerce/
├── archive-product.php                     # shop / category archive
├── single-product.php                      # single product page
├── content-product.php                     # product card in loops
├── cart/cart.php
├── checkout/form-checkout.php
├── myaccount/my-account.php
└── global/quantity-input.php
```

Find the source files in `wp-content/plugins/woocommerce/templates/` and copy the ones you need.

## Rules

- Use design-system tokens for all styling — no hardcoded colours, fonts, or sizes.
- Keep markup structure consistent with the Astro prototype's product/commerce components.
- Don't copy files you haven't modified — only override what you actually change (smaller upgrade surface).

## Theme support flags

Already declared in `functions.php`:

- `woocommerce`
- `wc-product-gallery-zoom`
- `wc-product-gallery-lightbox`
- `wc-product-gallery-slider`
