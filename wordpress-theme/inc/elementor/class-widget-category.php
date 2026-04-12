<?php
/**
 * Registers the custom Elementor widget category.
 *
 * @package {{THEME_NAME}}
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

add_action( 'elementor/elements/categories_registered', function ( $elements_manager ) {
    $elements_manager->add_category(
        '{{WIDGET_CATEGORY_SLUG}}',
        array(
            'title' => __( '{{WIDGET_CATEGORY_NAME}}', '{{THEME_TEXT_DOMAIN}}' ),
            'icon'  => 'fa fa-plug',
        )
    );
} );
