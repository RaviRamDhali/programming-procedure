<?php
/**
 * wp_nav_menu
 *
 * @link https://css-tricks.com/snippets/wordpress/remove-li-elements-from-output-of-wp_nav_menu/
 * @link https://developer.wordpress.org/reference/functions/wp_nav_menu/
 *
 * @package dhali
 *
 * Description: Removes ul and li tags from wp_nav_menu
 *
 */

if ( has_nav_menu( 'footer' ) ) {
	$footer_menu = array(
		'theme_location'	=> 'footer',
		'menu'						=> 'footer-menu',
		'menu_class'			=> 'footer-menu list',
		'depth'						=> 1,
		'container'				=> false,
		'echo'						=> false,
		'items_wrap'			=> '%3$s',
		'link_after'			=> '.',
		'after'						=> ' ',
	);

	echo strip_tags( wp_nav_menu( $footer_menu ), '<a>' );
}