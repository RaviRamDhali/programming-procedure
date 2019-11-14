<?php
/**
 * Register a Taxonomy media_cat.
 *
 * @link https://codex.wordpress.org/Function_Reference/register_taxonomy
 */

function dhali_attachment_taxonomy() {
	$labels = array(
		'name'              => _x( 'Media Categories', 'taxonomy general name' ),
		'singular_name'     => _x( 'Media Category', 'taxonomy singular name' ),
		'search_items'      => __( 'Search Media Categories' ),
		'all_items'         => __( 'All Media Categories' ),
		'parent_item'       => __( 'Parent Media Category' ),
		'parent_item_colon' => __( 'Parent Media Category:' ),
		'edit_item'         => __( 'Edit Media Category' ),
		'update_item'       => __( 'Update Media Category' ),
		'add_new_item'      => __( 'Add New Media Category' ),
		'new_item_name'     => __( 'New Media Category Name' ),
		'menu_name'         => __( 'Media Categories' ),
	);

	$args = array(
		'hierarchical'      => true,
		'labels'            => $labels,
		'show_ui'           => true,
		'show_admin_column' => true,
		'query_var'         => true,
		'rewrite'           => true,
	);

	register_taxonomy( 'media_cat', array( 'attachment' ), $args );
}
add_action( 'init', 'dhali_attachment_taxonomy', 0 );
