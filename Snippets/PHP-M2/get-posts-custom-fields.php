<?php

/*
 * Get Custom Fields
 *
 */


$args = array(
	'posts_per_page'	=> -1,
	'category_name'		=> 'courses',
	'post_status'			=> 'publish',
	'orderby'					=> 'date',
	'order'						=> 'ASC',
);

$posts = get_posts( $args );
foreach ( $posts as $post ) : setup_postdata( $post ); ?>

<li>
	<strong class="course-title"><?php the_title(); ?></strong><br>
	<?php echo get_the_content(); ?>

	<?php
		$course_date = get_post_meta( $post->ID, 'Course Date', true );
		$course_location = get_post_meta( $post->ID, 'Course Location', true );
		echo ''. $course_date .' | ' .$course_location .'';
	?>
</li>

<?php endforeach;	wp_reset_postdata(); ?>