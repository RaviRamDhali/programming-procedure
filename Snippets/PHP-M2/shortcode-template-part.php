<?php
/**
 * Shortcode with template part.
 *
 * @link http://wordpress.stackexchange.com/questions/89981/return-html-template-page-with-php-function
 *
 */

function my_form_shortcode() {
    ob_start();
    get_template_part('my_form_template');
    return ob_get_clean();   
} 
add_shortcode( 'my_form_shortcode', 'my_form_shortcode' );
