<?php

	$args = array(
		'posts_per_page'   => -1,
		'category_name'    => 'recipes',
		'orderby'          => 'date',
		'order'            => 'DESC',
		'post_type'        => 'post',
		'post_status'      => 'publish'
		);
	$query = new WP_Query( $args );
?>

<?php

$i = 1;
echo '<div class="grid grid-pad">';

if ( $query->have_posts() ) : while ( $query->have_posts() ) : $query->the_post(); ?>

<div class="grid-col col-3-12">
	<div class="media-border">
		<a href="<?php the_permalink(); ?>"><?php the_post_thumbnail( 'thumbnail', array( 'class' => 'media-fluid' ) ); ?></a>
	</div>
	<h6><?php the_title(); ?></h6>
	<a href="<?php the_permalink(); ?>">View The Recipe &rarr;</a>
</div><!-- /.grid-col -->

<?php if( $i % 4 == 0 ) { echo '</div><div class="grid grid-pad">'; } ?>

<?php $i++; endwhile; wp_reset_postdata(); else : ?>
	<p><?php _e( 'Sorry, no recipes at this moment.' ); ?></p>
<?php endif; echo '</div>';?>

--------------------------------------------------

		<div class="distributor-items">
			<div class="row">
				<?php
					$i = 1;
					foreach ( $distributors as $distributor ) {
							BuildDistributor( $distributor );
							if( $i % 4 == 0 ) { echo '</div><div class="row">'; } $i++;
					}
				?>
			</div>
		</div>
