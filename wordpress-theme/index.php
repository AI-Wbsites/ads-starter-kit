<?php
/**
 * Fallback template. Most pages are built with Elementor.
 *
 * @package {{THEME_NAME}}
 */

get_header();
?>
<main class="container section">
    <?php if ( have_posts() ) : ?>
        <?php while ( have_posts() ) : the_post(); ?>
            <article <?php post_class(); ?>>
                <h1><?php the_title(); ?></h1>
                <div class="entry-content">
                    <?php the_content(); ?>
                </div>
            </article>
        <?php endwhile; ?>
    <?php else : ?>
        <p><?php esc_html_e( 'Nothing here.', '{{THEME_TEXT_DOMAIN}}' ); ?></p>
    <?php endif; ?>
</main>
<?php
get_footer();
