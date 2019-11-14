<?php
/**
 * Change Query on Post Type
 */
function et_post( $query ) {
	if ( is_post_type_archive( 'clients' ) || is_post_type_archive( 'testimonial' ) ) {
		// Display all posts
		$query->set( 'posts_per_page', -1 );
		return;
	}
}
add_action( 'pre_get_posts', 'et_post', 1 );

/**
 * Change Query on Posts for Archive page and only on main query
 */
function et_post( $query ) {
	if ( is_archive( 'recipes' ) && $query->is_main_query() ) {
		// Display all posts
		$query->set( 'posts_per_page', -1 );
		return;
	}
}
add_action( 'pre_get_posts', 'et_post', 1 );

/**
 * Exclude Categories from Blog Article, Insights, Newsletter
 */
function wroten_post( $query ) {
	if ( is_home() && $query->is_main_query() ) {
		// Display all posts
		$query->set( 'category__not_in', array( 8, 9, 10 ) );
		return;
	}
}
add_action( 'pre_get_posts', 'wroten_post', 1 );
