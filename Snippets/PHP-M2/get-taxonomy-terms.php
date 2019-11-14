<?php

/**
 * The template for displaying courses archive pages.
 *
 * @package sdrtc
 */

get_header(); ?>

<?php
	//Get Query Object
	$term_list = get_queried_object();

	//Get Single Object (not array)
	$term = get_term( $term_list->term_id );

	//Get if object is parent
	$isParent = False;
	$isParent = ( $term->parent == 0 ) ? True : False;

	//Get Parent Name
	$term_parent = get_term( $term->parent );
?>


<div id="primary" class="content-area">
	<main id="main" class="site-main" role="main">
		<div class="grid grid-pad">
			<div class="col-1-1">

			<?php
				if( !$isParent ) {

				//start by fetching the terms for the courses taxonomy
					$terms = get_terms( array(
						'taxonomy' => 'courses',
						'orderby' => 'slug',
						'slug' => $term_list->slug
					) );

					// now run a query for each course
					foreach( $terms as $term ) {

						// Define the query
						$args = array(
							'post_type' => 'course',
							'order'  => 'ASC',
							'orderby' => 'title',
							'courses' => $term->slug
						);

					$query = new WP_Query( $args );

						echo '<header class="entry-header"><h1 class="entry-title">';
							echo '<a href="'. get_term_link( $term_parent ) .'">'. $term_parent->name .'</a>';
						echo '</h1></header>';

							echo'<h2>' . $term->name . '</h2>';

						// output the post titles in a list
						echo '<ul>';

						// Start the Loop
						while ( $query->have_posts() ) : $query->the_post(); ?>

						<li id="post-<?php the_ID(); ?>">
							<?php if ( $course_url = get_field('course_url') ) { ?>
								<a href="<?php echo $course_url; ?>"><?php the_title(); ?></a>

							<?php } else { ?>

								<a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
							<?php } ?>
						</li>

						<?php endwhile;

						echo '</ul>';
					}
				}
			?>

			<?php
			if( $isParent ) {

			$term = get_term_by( 'slug', get_query_var( 'term' ), get_query_var( 'taxonomy' ) );

			// Set tax name
			$taxonomyName = "courses";
			// $taxonomyName = "ca-post-certified-law-enforcement-training"

			// Get parents by tax
			$parents = get_terms( $taxonomyName, array(
				'orderby'			=> 'slug',
				 //'parent'			=> 0,
				 //'child_of'		=> 0,
				'include' => $term->term_id
			));

			foreach ($parents as $parent) {
				echo '<header class="entry-header"><h1 class="entry-title"><a href="'. get_term_link( $parent ) .'">'. $parent->name .'</a><br></h1></header>';

			//Get the Children
			$children = get_terms($taxonomyName, array(
				'parent' => $parent->term_id,
				'orderby' => 'slug'
			));

			foreach ($children as $child) {
				echo '<h2><a href="'. get_term_link( $child ) .'">'. $child->name .'</a></h2>';

			// Get Child
			$args = array(
				'post_type' => 'course',
				'order'  => 'ASC',
				'orderby' => 'title',
				$taxonomyName => $child->slug,
				'posts_per_page' => -1
			);

			$query = new WP_Query( $args );

			// output the post titles in a list
			echo '<ul>';

			// Start the Loop
			while ( $query->have_posts() ) : $query->the_post(); ?>

			<li id="post-<?php the_ID(); ?>">
				<?php if ( $course_url = get_field('course_url') ) { ?>
					<a href="<?php echo $course_url; ?>"><?php the_title(); ?></a>

				<?php } else { ?>

					<a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
				<?php } ?>
			</li>

			<?php endwhile;

			echo '</ul>';

				// use reset postdata to restore orginal query
				wp_reset_postdata();
					}
					echo '<hr>';
				}
			}
			?>

			</div><!-- col-1-1 -->
		</div>
	</main><!-- #main -->
</div><!-- #primary -->
<?php get_footer(); ?>
