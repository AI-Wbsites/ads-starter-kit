<?php
/**
 * TEMPLATE — copy to inc/post-types/<slug>.php, rename symbols,
 * then enable it in functions.php $modules list.
 *
 * @package {{THEME_NAME}}
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

add_action( 'init', function () {
    register_post_type(
        'project',
        array(
            'labels' => array(
                'name'          => __( 'Projects', '{{THEME_TEXT_DOMAIN}}' ),
                'singular_name' => __( 'Project',  '{{THEME_TEXT_DOMAIN}}' ),
            ),
            'public'       => true,
            'show_in_rest' => true,
            'menu_icon'    => 'dashicons-portfolio',
            'has_archive'  => true,
            'rewrite'      => array( 'slug' => 'projects' ),
            'supports'     => array( 'title', 'editor', 'thumbnail', 'excerpt', 'elementor' ),
        )
    );
} );
