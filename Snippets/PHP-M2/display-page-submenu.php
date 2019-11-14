<?
/**
 * If its specific page
 */

?>

<?php if ( is_page( 'about-us' ) || '5' == $post->post_parent ) {
	// Displays Open an Escrow Menu if this is an 'about-us' page or child of an 'about-us' page.

	$menu_escrow = '83'; //Escrow Page ID
	$children = wp_list_pages("title_li=&child_of=".$menu_escrow."&echo=0");

	if ($children) {
		//Page Title
		echo '<h2>'.get_the_title( $menu_escrow ).'</h2>';
	}

	echo '<ul class="sidebar-list">'.$children.'</ul>';

} else {
	// This is not a subpage of an 'about-us' page
	echo 'not-about-us';
}
?>

<?
/**
 * Displays Sub Pages of Parent Page with Title
 */

?>

<?php
	if($post->post_parent)
		$children = wp_list_pages("title_li=&child_of=".$post->post_parent."&echo=0");
	else
		$children = wp_list_pages("title_li=&child_of=".$post->ID."&echo=0");
	if ($children) { ?>
	<h2>
		<?php
			echo empty( $post->post_parent ) ? get_the_title( $post->ID ) : get_the_title( $post->post_parent );
		?>
	</h2>
	<ul class="sidebar-list">
		<?php echo $children; ?>
	</ul>
<?php } ?>
