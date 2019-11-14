<?php
/**
 * Woothemes features template
 *
 */


add_action('woothemes_features_item_template', 'woo_features_template_order');
function woo_features_template_order ( $tpl ) {

	$tpl = '<div class="%%CLASS%%"><h3 class="feature-title">%%TITLE%%</h3><div class="feature-image">%%IMAGE%%</div><div class="feature-content">%%CONTENT%%</div></div>';

	return $tpl;

}

?>
