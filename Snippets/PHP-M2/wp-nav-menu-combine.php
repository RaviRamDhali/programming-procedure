<?php
/**
 * wp_nav_menu
 *
 * Description: Combines 2 menus
 *
 */

// Combines 2 menus into 1 list item
if ( has_nav_menu( 'primary' ) && has_nav_menu( 'utilities' ) ) {
	$menu = wp_nav_menu( array(
		'menu'              => 'utilities',
		'theme_location'    => 'utilities',
		'depth'             => 1,
		'container'         => false,
		'items_wrap' 				=> '%3$s',
		'echo'							 => false
	));
	wp_nav_menu( array(
		'menu'              => 'primary',
		'theme_location'		=> 'primary',
		'depth'             => 1,
		'container'         => false,
		'menu_class'        => 'list-unstyled list-navigation',
		'items_wrap' => '<ul id="%1$s" class="%2$s hidden-xs">%3$s' . $menu . '</ul>',
	));
}