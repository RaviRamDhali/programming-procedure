<?php

/**
 * Exclude Categories from Categories Widget Article, Insights, Newsletter
 */
function exclude_widget_categories($args) {
	$exclude = "8,9,10"; // The IDs of the excluding categories
	$args["exclude"] = $exclude;
	return $args;
}
add_filter("widget_categories_args","exclude_widget_categories");

/**
 * Exclude Categories from Recent Posts Widget Article, Insights, Newsletter
 */
function exclude_recent_posts($args ) {
	$args['category__not_in'] = array( 8, 9, 10 );
	return $args ;
}
add_filter("widget_posts_args","exclude_recent_posts");