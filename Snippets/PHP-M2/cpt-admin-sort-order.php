/**
 * Set Sort Order for CPT in Admin
 */
function dhali_project_admin_sort( $query ){
  if( !is_admin() )
      return;

  $screen = get_current_screen();
  if( 'edit' == $screen->base
  && 'dhali_project' == $screen->post_type
  && !isset( $_GET['orderby'] ) ){
      $query->set( 'orderby', 'menu_order' );
      $query->set( 'order', 'ASC' );
  }
}
add_action( 'pre_get_posts', 'dhali_project_admin_sort' );
