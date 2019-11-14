<?php
/**
 * Register a Retailer post type.
 *
 * @link http://codex.wordpress.org/Function_Reference/register_post_type
 */

function dhali_retailers() {
	$labels = array(
		'name'               => _x( 'Retailers', 'post type general name', 'dhali' ),
		'singular_name'      => _x( 'Retailer', 'post type singular name', 'dhali' ),
		'menu_name'          => _x( 'Retailers', 'admin menu', 'dhali' ),
		'name_admin_bar'     => _x( 'Retailer', 'add new on admin bar', 'dhali' ),
		'add_new'            => _x( 'Add New', 'Retailer', 'dhali' ),
		'add_new_item'       => __( 'Add New Retailer', 'dhali' ),
		'new_item'           => __( 'New Retailer', 'dhali' ),
		'edit_item'          => __( 'Edit Retailer', 'dhali' ),
		'view_item'          => __( 'View Retailer', 'dhali' ),
		'all_items'          => __( 'All Retailers', 'dhali' ),
		'search_items'       => __( 'Search Retailers', 'dhali' ),
		'parent_item_colon'  => __( 'Parent Retailers:', 'dhali' ),
		'not_found'          => __( 'No Retailers found.', 'dhali' ),
		'not_found_in_trash' => __( 'No Retailers found in Trash.', 'dhali' )
	);

	$args = array(
		'labels'             => $labels,
		'description'        => __( 'Shows Retailers', 'dhali' ),
		'public'             => true,
		'publicly_queryable' => false,
		'show_ui'            => true,
		'show_in_menu'       => true,
		'exclude_from_search'=> true,
		'query_var'          => true,
		'rewrite'            => array( 'slug' => 'retailer' ),
		'capability_type'    => 'post',
		'has_archive'        => false,
		'hierarchical'       => false,
		'menu_position'      => null,
		'menu_icon'          => 'dashicons-cart',
		'supports'           => array( 'title', 'editor' )
	);

	register_post_type( 'retailer', $args );
}
add_action( 'init', 'dhali_retailers' );


/**
 * Register a Taxonomy.
 *
 * @link https://codex.wordpress.org/Function_Reference/register_taxonomy
 */

function dhali_retailers_taxonomy() {
	$labels = array(
		'name'              => _x( 'Locations', 'taxonomy general name' ),
		'singular_name'     => _x( 'Location', 'taxonomy singular name' ),
		'search_items'      => __( 'Search Locations' ),
		'all_items'         => __( 'All Locations' ),
		'parent_item'       => __( 'Parent Location' ),
		'parent_item_colon' => __( 'Parent Location:' ),
		'edit_item'         => __( 'Edit Location' ),
		'update_item'       => __( 'Update Location' ),
		'add_new_item'      => __( 'Add New Location' ),
		'new_item_name'     => __( 'New Location Name' ),
		'menu_name'         => __( 'Location' ),
	);

	$args = array(
		'hierarchical'      => true,
		'labels'            => $labels,
		'show_ui'           => true,
		'show_admin_column' => true,
		'query_var'         => true,
		'rewrite'           => array( 'slug' => 'location' ),
	);

	register_taxonomy( 'location', array( 'retailer' ), $args );
}
add_action( 'init', 'dhali_retailers_taxonomy', 0 );
