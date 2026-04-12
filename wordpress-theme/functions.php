<?php
/**
 * {{THEME_NAME}} theme bootstrap.
 *
 * Targets the latest stable PHP. Minimum PHP 8.2.
 * Modern features encouraged: enums, readonly properties/classes, first-class
 * callable syntax, named arguments, typed class constants (PHP 8.3), etc.
 *
 * @package {{THEME_NAME}}
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

define( '{{THEME_CONST_PREFIX}}_THEME_VERSION', '0.1.0' );
define( '{{THEME_CONST_PREFIX}}_THEME_DIR',     get_template_directory() );
define( '{{THEME_CONST_PREFIX}}_THEME_URI',     get_template_directory_uri() );

/**
 * Theme supports.
 */
add_action( 'after_setup_theme', function () {
    load_theme_textdomain( '{{THEME_TEXT_DOMAIN}}', get_template_directory() . '/languages' );

    add_theme_support( 'title-tag' );
    add_theme_support( 'post-thumbnails' );
    add_theme_support( 'html5', array( 'search-form', 'comment-form', 'comment-list', 'gallery', 'caption', 'style', 'script' ) );
    add_theme_support( 'responsive-embeds' );
    add_theme_support( 'align-wide' );

    // WooCommerce — harmless if WC isn't installed. Override templates in /woocommerce/.
    add_theme_support( 'woocommerce' );
    add_theme_support( 'wc-product-gallery-zoom' );
    add_theme_support( 'wc-product-gallery-lightbox' );
    add_theme_support( 'wc-product-gallery-slider' );

    register_nav_menus( array(
        'primary' => __( 'Primary', '{{THEME_TEXT_DOMAIN}}' ),
        'footer'  => __( 'Footer',  '{{THEME_TEXT_DOMAIN}}' ),
    ) );
} );

/**
 * Frontend assets — design-system tokens, theme CSS, shared JS.
 */
add_action( 'wp_enqueue_scripts', function () {
    $ver = {{THEME_CONST_PREFIX}}_THEME_VERSION;
    $uri = get_template_directory_uri();

    // Google Fonts — keep in sync with design-system/typography.css
    wp_enqueue_style(
        '{{THEME_TEXT_DOMAIN}}-google-fonts',
        'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap',
        array(),
        null
    );

    // Design-system tokens (order matters: tokens → typography → animations → theme).
    wp_enqueue_style( '{{THEME_TEXT_DOMAIN}}-tokens',     "$uri/assets/css/tokens.css",     array(), $ver );
    wp_enqueue_style( '{{THEME_TEXT_DOMAIN}}-typography', "$uri/assets/css/typography.css", array( '{{THEME_TEXT_DOMAIN}}-tokens' ), $ver );
    wp_enqueue_style( '{{THEME_TEXT_DOMAIN}}-animations', "$uri/assets/css/animations.css", array( '{{THEME_TEXT_DOMAIN}}-tokens' ), $ver );
    wp_enqueue_style( '{{THEME_TEXT_DOMAIN}}-theme',      "$uri/assets/css/theme.css",      array( '{{THEME_TEXT_DOMAIN}}-tokens', '{{THEME_TEXT_DOMAIN}}-typography', '{{THEME_TEXT_DOMAIN}}-animations' ), $ver );

    wp_enqueue_script( '{{THEME_TEXT_DOMAIN}}-motion', "$uri/assets/js/motion.js", array(), $ver, true );
} );

/**
 * Post types, taxonomies, fields — auto-loaded.
 * Drop a file into the matching folder, it runs. Keep each module small and
 * test it in WP admin after adding.
 */
foreach ( array( 'post-types', 'taxonomies', 'fields' ) as $dir ) {
    foreach ( glob( get_template_directory() . "/inc/$dir/*.php" ) as $file ) {
        // Skip templates (filenames with ".template" segment).
        if ( str_contains( $file, '.template.' ) ) {
            continue;
        }
        require_once $file;
    }
}

/**
 * Elementor integration — custom widget category + widgets.
 *
 * Widgets auto-load by filename convention:
 *   inc/elementor/widgets/class-<slug>-widget.php
 *   → class \{{THEME_NAME}}\Widgets\<Slug>_Widget (Slug in PascalCase with underscores)
 *
 * Drop a properly-named file in that folder, it registers itself under the
 * {{WIDGET_CATEGORY_SLUG}} category. No edits to this file required.
 *
 * Workflow discipline: add ONE widget at a time, test it in Elementor, then
 * move to the next. This is a process rule, not a loader rule.
 */
if ( did_action( 'elementor/loaded' ) || defined( 'ELEMENTOR_VERSION' ) ) {
    require_once get_template_directory() . '/inc/elementor/class-widget-category.php';

    add_action( 'elementor/widgets/register', function ( $widgets_manager ) {
        $widgets_dir = get_template_directory() . '/inc/elementor/widgets/';
        $files = glob( $widgets_dir . 'class-*-widget.php' );
        if ( ! $files ) {
            return;
        }

        foreach ( $files as $file ) {
            require_once $file;

            // class-hero-widget.php → \{{THEME_NAME}}\Widgets\Hero_Widget
            $base  = basename( $file, '.php' );                 // class-hero-widget
            $slug  = substr( $base, strlen( 'class-' ) );       // hero-widget
            $parts = array_map( 'ucfirst', explode( '-', $slug ) );
            $class = '\\{{THEME_NAME}}\\Widgets\\' . implode( '_', $parts );

            if ( class_exists( $class ) ) {
                $widgets_manager->register( new $class() );
            }
        }
    } );
}
