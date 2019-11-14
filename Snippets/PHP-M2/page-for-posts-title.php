<?php
/**
 * Get the title of the page for posts option.
 *
 * @link https://developer.wordpress.org/reference/functions/get_template_part/
 *
 */

echo get_the_title( get_option('page_for_posts', true) );

