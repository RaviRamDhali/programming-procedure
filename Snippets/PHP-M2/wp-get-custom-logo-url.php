<?php
/**
 *
 * Gets the url of the custom logo
 * @link https://codex.wordpress.org/Theme_Logo
 *
 */
function get_custom_logo_url() {
  $custom_logo_id = get_theme_mod( 'custom_logo' );
  $image = wp_get_attachment_image_src( $custom_logo_id , 'full' );

  return $image[0];
}
