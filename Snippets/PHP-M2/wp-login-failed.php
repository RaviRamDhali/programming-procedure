<?php
/**
 * Custom redirect login failed
 *
 */

add_action('wp_login_failed', 'login_failure_redirect');

function login_failure_redirect(){
	$current_url = $_SERVER['HTTP_REFERER'];
	// if there's a valid referrer, and it's not the default log-in screen
		if(!empty($current_url) && !strstr($current_url,'wp-login') && !strstr($current_url,'wp-admin')){

		// let's append some information (login=failed) to the URL for the theme to use
		wp_redirect($current_url .'?login=failed');
		exit;

	}
}
