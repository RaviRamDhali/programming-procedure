<?php
/**
 * Generates Shortcodes
 *
 * @package dhali
 */

// Displays Features Grid Shortcode
function dhali_features_func() {

	$terms = get_terms( array(
		'taxonomy' => 'category',
		'parent' => 15,
		'hide_empty' => false,
	) );

	var_dump( $terms );

	$output = '';

	foreach ( $terms as $term ) {

		$output .= '<h2>'. $term->name .'</h2>';

		$args = array(
			'posts_per_page'	=> -1,
			'post_type'				=> 'attachment',
			'category_name'    => $term->name,
		);

		$features = get_posts( $args );

		$output .= '<div class="row">';

			foreach ( $features as $feature ):

			$output .= '<div class="col-xs-6 col-sm-4 col-md-3">';
					$output .= wp_get_attachment_image( $feature->ID, 'full', false, array( 'class' => 'img-responsive center-block' ) );
					$output .= '<p>'. $feature->post_content .'</p>';
			$output .=  '</div>';

			endforeach;

		$output .= '</div>';
	}

	return $output;
}
add_shortcode( 'dewalt_features', 'dhali_features_func' );
