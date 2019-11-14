<?php
/**
 * Template Name: Parent Page Redirect
 * Description: Empty Page (redirect page) 
 *
 * @link https://wordpress.stackexchange.com/questions/120240/strategy-for-handling-hierarchical-pages-with-empty-parent-content
 *
 * @package dhali
 */

  $rp = new WP_Query( array(
    'post_parent'   => get_the_id(),
    'post_type'     => 'page',
    'order'         => 'asc',
    'orderby'       => 'menu_order'
  ));

  if ($rp->have_posts())
    while ( $rp->have_posts() ) { 
      $rp->the_post(); 
      wp_redirect(get_permalink(get_the_id()));
      exit;
    }   
  wp_redirect(dirname(home_url($wp->request)));
  exit;