<?php
/**
 * Sorting using meta_query custom field
 *
 * @link https://wordpress.stackexchange.com/questions/188287/orderby-meta-value-only-returns-posts-that-have-existing-meta-key
 *
 */

$termChildren = get_terms( array(
	'taxonomy' 		=> $termTaxonomy,
	'hide_empty' 	=> false,
	'orderby'			=> 'meta_value_num',
	'order'				=> 'ASC',
	'meta_query'	=> array(
		'relation'	=> 'OR',
		array(
		  'key'=>'program_cat_sort_order',
		  'compare' => 'EXISTS'
		),
		array(
		  'key'=>'program_cat_sort_order',
		  'compare' => 'NOT EXISTS'
		)
	),
	'parent' 	=> $termParent->term_id
) );

