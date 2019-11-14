<?php
/**
 * Displays Event Meta Box
 *
 * @link https://developer.wordpress.org/reference/functions/add_meta_box/
 *
 * @package dhali
 */

/**
 * Create Meta Box
 */
function dhali_event_metabox() {
	 add_meta_box( 'dhali_event_metabox', __( 'Event Details', 'dhali' ), 'dhali_display_event_fields', 'post', 'side', 'high' );
}
add_action( 'add_meta_boxes', 'dhali_event_metabox' );

/**
 * Display Event Fields
 */
function dhali_display_event_fields( $post ) {

	// Event Date Fields
	$event_month = get_post_meta( $post->ID, 'event_month', true );
	$event_day = get_post_meta( $post->ID, 'event_day', true );
	$event_year = get_post_meta( $post->ID, 'event_year', true );

	echo '<p>Event Date:</p>';
	echo '<input type="text" name="event_month" value="' . $event_month  . '" size="3" maxlength="3" placeholder="Month"/>';
	echo '<input type="text" name="event_day" value="' . $event_day  . '" size="2" maxlength="2" placeholder="Day"/>';
	echo '<input type="text" name="event_year" value="' . $event_year . '" size="4" maxlength="4" placeholder="Year"/>';

	// Event Location textarea
	$event_location = get_post_meta( $post->ID, 'event_location', true );
	echo '<p><label for="event_location">Event Location:</label></p>';
	echo '<textarea id="event_location" name="event_location" class="" value="" style="width: 100%;">' . $event_location  . '</textarea>';
}

/**
 * Save Event Fields
 */
function dhali_save_event_fields( $post_id ) {

	// Save Month field
	if( isset( $_POST['event_month'] ) ) {
		update_post_meta( $post_id, 'event_month', $_POST['event_month'] );
	}

	// Save Day field
	if( isset( $_POST['event_day'] ) ) {
		update_post_meta( $post_id, 'event_day', $_POST['event_day'] );
	}

	// Save Year field
	if( isset( $_POST['event_year'] ) ) {
		update_post_meta( $post_id, 'event_year', $_POST['event_year'] );
	}

	// Save Event Location field
	if( isset( $_POST['event_location'] ) ) {
		update_post_meta( $post_id, 'event_location', $_POST['event_location'] );
	}

}
add_action( 'save_post', 'dhali_save_event_fields', 10, 1 );
