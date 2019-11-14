<?php
/**
 * Get url by page title
 *
 * @link https://codex.wordpress.org/Function_Reference/get_page_by_title
 */

$page_url = get_permalink( get_page_by_title( 'Page Name' ) );

/**
 * Gets page url by title
 */
function dhali_page_url($name) {
  return get_permalink( get_page_by_title( $name ) );
}
