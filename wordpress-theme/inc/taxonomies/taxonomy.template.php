<?php
/**
 * TEMPLATE — copy to inc/taxonomies/<slug>.php, rename symbols,
 * then enable it in functions.php $modules list.
 *
 * @package {{THEME_NAME}}
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

add_action( 'init', function () {
    register_taxonomy(
        'project_category',
        array( 'project' ),
        array(
            'labels' => array(
                'name'          => __( 'Project Categories', '{{THEME_TEXT_DOMAIN}}' ),
                'singular_name' => __( 'Project Category',   '{{THEME_TEXT_DOMAIN}}' ),
            ),
            'hierarchical' => true,
            'public'       => true,
            'show_in_rest' => true,
            'rewrite'      => array( 'slug' => 'project-category' ),
        )
    );
} );
