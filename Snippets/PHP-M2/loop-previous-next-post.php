/**
 * Project Navigation for Previous/Next Project
 *
 * @link https://gist.github.com/banago/5603826#file-infinite-previous-next-looping-php
 *
 */
function dhali_project_navigation() { ?>
  <div class="project-navigation">
    <nav class="navigation post-navigation" role="navigation">
      <h2 class="screen-reader-text">Post navigation</h2>
      <div class="nav-links">
        <?php if( get_adjacent_post(false, '', true) ) {
          echo '<div class="nav-previous">';
            previous_post_link('%link', 'Previous Project');
          echo '</div>';
        } else {
          $first = new WP_Query('post_type=dhali_project&posts_per_page=1&order=DESC');
          $first->the_post();
          echo '<div class="nav-previous"><a href="' . get_permalink() . '">Previous Project</a></div>';
          wp_reset_query();
        };

        if( get_adjacent_post(false, '', false) ) {
          echo '<div class="nav-next">';
            next_post_link('%link', 'Next Project');
          echo '</div>';
        } else {
          $last = new WP_Query('post_type=dhali_project&posts_per_page=1&order=ASC');
          $last->the_post();
          echo '<div class="nav-next"><a href="' . get_permalink() . '">Next Project</a></div>';
          wp_reset_query();
        }; ?>
      </div><!-- /.nav-links -->
    </nav><!-- /.post-navigation -->
  </div><!-- /.project-navigation -->
<?php }
