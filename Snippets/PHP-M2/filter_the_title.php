<?php
/**
 * Filters the title for the homepage
 */
function dhali_welcome_title( $title, $id ) {
	if ( is_front_page() && in_the_loop() ) {
		$title = 'Welcome to ' . get_bloginfo( 'name' );
	}
	return $title;
}
add_filter( 'the_title', 'dhali_welcome_title', 10, 2 );