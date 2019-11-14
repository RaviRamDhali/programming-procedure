<?php
/**
 *
 * Changes the logo for the login page
 * @link https://codex.wordpress.org/Customizing_the_Login_Form
 *
 */
function dhali_login_logo() { ?>
  <style type="text/css">
    #login h1 a,
    .login h1 a {
      background-image: url(<?php echo get_stylesheet_directory_uri(); ?>/images/site-login-logo.png);
      height: 120px;
      width: 320px;
      background-size: contain;
    }
  </style>
<?php }
add_action( 'login_enqueue_scripts', 'dhali_login_logo' );
