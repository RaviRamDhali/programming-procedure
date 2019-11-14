<?php
/**
 * Add Note to Featured Image Meta Box
 *
 */
function dhali_post_thumbnail_html( $content ) {
    return $content .= '1400x600px - <small><em>Recommended Image Dimensions</em></small>';
}
add_filter( 'admin_post_thumbnail_html', 'dhali_post_thumbnail_html');
