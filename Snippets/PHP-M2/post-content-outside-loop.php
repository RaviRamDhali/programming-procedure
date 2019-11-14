<?php
/**
 * displaying post content outside of loop.
 *
 * @link https://wordpress.stackexchange.com/questions/142957/use-the-content-outside-the-loop
 *
 * @package dhali
 */

global $post;

// Checks if post has content. Can use $post or get_post()
if( '' == $post->post_content ) {
	return;
}
?>

<div class="intro-content mb-30"><?php
	echo $post->post_content; ?>
</div><!-- /.intro-content -->
