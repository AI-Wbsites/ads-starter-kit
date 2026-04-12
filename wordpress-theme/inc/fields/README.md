# Custom fields

Where field definitions live. Agnostic — pick the approach that fits the project:

## Option 1: Native `register_meta()` (free, built-in)

Best when fields are simple (strings, numbers, booleans) and edited through Gutenberg or Elementor's own controls.

```php
// inc/fields/project-fields.php
add_action( 'init', function () {
    register_post_meta( 'project', 'client_name', [
        'type'         => 'string',
        'single'       => true,
        'show_in_rest' => true,
        'auth_callback' => fn() => current_user_can( 'edit_posts' ),
    ] );
} );
```

Enable in `functions.php` `$modules` list.

## Option 2: Advanced Custom Fields (ACF / ACF Pro)

Best when you want a polished editor UI, repeaters, flexible content, or Elementor Dynamic Tags backed by ACF Pro.

- Install ACF (or ACF Pro) as a plugin.
- Register field groups via PHP in `inc/fields/<slug>.php` using `acf_add_local_field_group()` — keeps fields versioned with the theme.
- Add the file to `functions.php` `$modules` list.

## Option 3: Meta Box, CMB2, Carbon Fields

Same pattern as ACF — each has its own PHP registration API. Pick one per project; don't mix.

## Rules

- Field definitions belong in this folder, not scattered across the codebase.
- One file per post type's fields, named `<post-type-slug>-fields.php`.
- Register via `$modules` in `functions.php` — explicit, one line per file.
