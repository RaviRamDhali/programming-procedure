<?php
/**
 * MetaBoxes
 *
 * @link https://developer.wordpress.org/reference/functions/add_meta_box/
 * @link https://premium.wpmudev.org/blog/creating-meta-boxes/?utm_expid=3606929-101._J2UGKNuQ6e7Of8gblmOTA.0
 * @link https://www.smashingmagazine.com/2011/10/create-custom-post-meta-boxes-wordpress/
 *
 * @package dhali
 */

/**
 * Register Meta Boxes
 *
 */
function dhali_register_meta_boxes( $post_type, $post ) {
	add_meta_box( 'dhali_client_url', 'URL', 'dhali_client_url_metabox', 'clients', 'normal', 'high' );
}
add_action( 'add_meta_boxes', 'dhali_register_meta_boxes', 10, 2 );

/**
 * Meta box display callback.
 *
 * @param WP_Post $post Current post object.
 */
function dhali_client_url_metabox( $post ) {

	wp_nonce_field( basename( __FILE__ ), 'dhali_client_url_nonce' );
	$client_url = get_post_meta( $post->ID, 'dhali_client_url', true );

	?>

	<div class="form-field">
		<input type="text" name="dhali_client_url" id="dhali_client_url" value="<?php echo $client_url ?>" style="width: 100%;" placeholder="http://www.google.com">
	</div>

<?php }

/**
 * Save meta box content.
 *
 * @param int $post_id Post ID
 */
function dhali_save_url_metabox( $post_id ) {

	// verify meta box nonce
	if ( !isset( $_POST['dhali_client_url_nonce'] ) || !wp_verify_nonce( $_POST['dhali_client_url_nonce'], basename( __FILE__ ) ) ){
		return;
	}

	// return if autosave
	if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE ){
		return;
	}

	// Check the user's permissions.
	if ( !current_user_can( 'edit_post', $post_id ) ){
		return;
	}

	if( isset( $_POST['dhali_client_url'] ) && '' !== $_POST['dhali_client_url'] ) {

		$dhali_client_url = sanitize_text_field( $_POST['dhali_client_url'] );
		update_post_meta( $post_id, 'dhali_client_url', $dhali_client_url );

	} else {

		delete_post_meta( $post_id, 'dhali_client_url' );
	}

}
add_action( 'save_post', 'dhali_save_url_metabox', 10, 2 );