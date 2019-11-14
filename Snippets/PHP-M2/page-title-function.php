<?php
/**
 * Function to return page title
 */
 
function dhali_page_title() {

  if ( is_tax( 'dhali_product_cat' ) ) :
    $term = get_queried_object();
    $page_title = $term->name;

  elseif ( is_post_type_archive( 'dhali_project' ) || is_singular( 'dhali_project' ) ) :
    $page_title = 'Cool Client Projects';

  elseif ( is_archive() ) :
    $page_title = get_the_archive_title();

  elseif ( is_404() ) :
    $page_title = esc_html_e( 'Oops! That page can&rsquo;t be found.', 'dhali' );

  elseif ( is_search() ) :
    $page_title = sprintf( esc_html__( 'Search Results for: %s', 'dhali' ), get_search_query() );

  elseif ( is_single() ) :
    $page_title = 'Blog';

  else :
    $page_title = single_post_title('', false);

  endif;
  return $page_title;
}
