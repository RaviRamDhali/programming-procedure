<?php
/**
 * Snippet for displaying copyright footer with Terms and Privacy Policy links
 *
 */

$terms = get_page_by_title( 'Terms of Use' );
$privacy = get_page_by_title( 'Privacy Policy' );
$terms_link = ( isset( $terms ) ) ? '<span class="sep"> | </span> <a href='. get_permalink( $terms ) .'>'. $terms->post_title .'</a>' : '' ;
$privacy_link = ( isset( $privacy ) ) ? '<span class="sep"> | </span> <a href='. get_permalink( $privacy ) .'>'. $privacy->post_title .'</a>' : '' ;

$copyright = '&copy; ' . date('Y') . ' ' . get_bloginfo( 'name' ). ', ';
$copyright .= __( 'All Rights Reserved', 'dhali' );
$copyright .= $privacy_link . $terms_link;
