<?php 
/**
 * Read More: http://richardsweeney.com/add-a-category-to-media-items-in-wordpress/
*/

/** Register taxonomy for images */
function olab_register_taxonomy_for_images() {
    register_taxonomy_for_object_type( 'category', 'attachment' );
}
add_action( 'init', 'olab_register_taxonomy_for_images' );

/** Add a category filter to images */
function olab_add_image_category_filter() {
    $screen = get_current_screen();
    if ( 'upload' == $screen->id ) {
        $dropdown_options = array( 'show_option_all' => __( 'View all categories', 'olab' ), 'hide_empty' => false, 'hierarchical' => true, 'orderby' => 'name', );
        wp_dropdown_categories( $dropdown_options );
    }
}
add_action( 'restrict_manage_posts', 'olab_add_image_category_filter' );

?>
