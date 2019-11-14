<?php
// -----------------------------
$args = array(
	'cat' => 3,
	'posts_per_page' => 2
	);
$query = new WP_Query( $args );
?>

<?php if ( $query->have_posts() ) : while ( $query->have_posts() ) : $query->the_post(); ?>

<strong><?php the_title(); ?></strong>
<?php the_content(); ?>

<?php endwhile; wp_reset_postdata(); else : ?>
	<p>There are no post</p>
<?php endif; ?>
