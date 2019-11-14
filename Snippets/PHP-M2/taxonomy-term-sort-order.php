<?php
/**
 * Adds sort_order field to product_cat Taxonomy and category Taxonomy
 *
*/
function dhali_sort_meta( $taxonomy ) {	?>

	<div class="form-field term-sort-order-wrap">
		<label for="sort_order"><?php _e( 'Sort Order', 'dhali' ); ?></label>
		<input type="text" name="sort_order" id="sort_order" value="">
		<p class="description"><?php _e( 'Enter the category sort order','dhali' ); ?></p>
	</div>

<?php }
add_action( 'product_cat_add_form_fields', 'dhali_sort_meta', 10, 1 );
add_action( 'category_add_form_fields', 'dhali_sort_meta', 10, 1 );

function dhali_save_sort_meta( $term_id, $tt_id ) {

	if( isset( $_POST['sort_order'] ) && '' !== $_POST['sort_order'] ) {

		$sort_order = $_POST['sort_order'];
		add_term_meta( $term_id, 'sort_order', $sort_order, true );

	}
}
add_action( 'created_product_cat', 'dhali_save_sort_meta', 10, 2 );
add_action( 'created_category', 'dhali_save_sort_meta', 10, 2 );

function dhali_edit_sort_meta( $term, $taxonomy ) {

	$sort_order = get_term_meta( $term->term_id, 'sort_order', true ); ?>

		<tr class="form-field term-group-wrap">
			<th scope="row"><label for="sort_order"><?php _e( 'Sort Order', 'dhali' ); ?></label></th>
			<td><input type="text" name="sort_order" id="sort_order" value="<?php echo $sort_order ?>">
				<p class="description"><?php _e( 'Enter the category sort order','dhali' ); ?></p>
			</td>
		</tr><?php

}
add_action( 'product_cat_edit_form_fields', 'dhali_edit_sort_meta', 10, 2 );
add_action( 'category_edit_form_fields', 'dhali_edit_sort_meta', 10, 2 );

function dhali_update_sort_meta( $term_id, $tt_id ) {

	if( isset( $_POST['sort_order'] ) && '' !== $_POST['sort_order'] ) {

		$sort_order = $_POST['sort_order'];
		update_term_meta( $term_id, 'sort_order', $sort_order );

	}
}
add_action( 'edited_product_cat', 'dhali_update_sort_meta', 10, 2 );
add_action( 'edited_category', 'dhali_update_sort_meta', 10, 2 );

/**
 * Adds sort_order column in product_cat table
 *
*/

function dhali_sort_order_column( $columns ) {

	$columns['sort_order_column'] = __( 'Sort Order', 'dhali' );
	return $columns;

}
add_filter('manage_edit-product_cat_columns', 'dhali_sort_order_column' );
add_filter('manage_edit-category_columns', 'dhali_sort_order_column' );

function dhali_sort_order_column_content( $content, $column_name, $term_id ) {

		if( $column_name !== 'sort_order_column' ) {
				return $content;
		}

		$term_id = absint( $term_id );
		$sort_order = get_term_meta( $term_id, 'sort_order', true );

		if( !empty( $sort_order ) && $column_name == 'sort_order_column' ) {
			$content .= $sort_order;
		}

		return $content;
}
add_filter('manage_product_cat_custom_column', 'dhali_sort_order_column_content', 10, 3 );
add_filter('manage_category_custom_column', 'dhali_sort_order_column_content', 10, 3 );

// function dhali_sort_order_column_sortable( $sortable ) {

// 	$sortable[ 'sort_order_column' ] = 'sort_order_column';
// 	return $sortable;

// }
// add_filter( 'manage_edit-product_cat_sortable_columns', 'dhali_sort_order_column_sortable' );
