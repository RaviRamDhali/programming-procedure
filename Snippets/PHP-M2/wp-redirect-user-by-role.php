<?php
/**
 *
 * Redirect User if subscriber
 * @link https://code.tutsplus.com/tutorials/redirect-users-to-custom-pages-by-role--wp-33505
 *
 */
function dhali_redirect_users_by_role() {

  $redirect_url = get_permalink( get_page_by_title( 'Courses' ) );

    if ( ! defined( 'DOING_AJAX' ) ) {
      $current_user   = wp_get_current_user();
      $role_name      = $current_user->roles[0];

      if ( 'subscriber' === $role_name ) {
        wp_redirect( $redirect_url );
      }
    }
}
add_action( 'admin_init', 'dhali_redirect_users_by_role' );
