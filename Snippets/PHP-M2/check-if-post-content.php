<?php
/**
 * wp_nav_menu
 *
 * @link http://wordpress.stackexchange.com/questions/121359/if-the-post-has-content
 *
 * @package dhali
 *
 * Description: checks to see if the post has content.
 *
 */

// Use $post or get_post() instead:
if( '' !== get_post()->post_content ) {
	// do something
}