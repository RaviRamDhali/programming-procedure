<?php

/**
 * Adds Icon_Widget widget.
 */
class Icon_Widget extends WP_Widget {

	/**
	 * Register widget with WordPress.
	 */
	function __construct() {
		parent::__construct(
			'icon_widget', // Base ID
			__( 'Icon Widget', 'dhali' ), // Name
			array( 'description' => __( 'Icon widget w/description and link', 'dhali' ), ) // Args
		);
	}

	/**
	 * Front-end display of widget.
	 *
	 * @see WP_Widget::widget()
	 *
	 * @param array $args     Widget arguments.
	 * @param array $instance Saved values from database.
	 */
	public function widget( $args, $instance ) {
		echo $args['before_widget'];

			echo '<div class="row">';
				echo '<div class="col-xs-6 col-xs-offset-3 col-md-4 col-md-offset-0  col-lg-3 text-center">';
					echo '<div class="quick-links-icon"><a href="'. $instance['link'] .'"><span class="'. $instance['icon'] .'" aria-hidden="true"></span></a></div>';
				echo '</div>';

				echo '<div class="col-xs-12 col-md-8 col-lg-9">';
					if ( ! empty( $instance['title'] ) ) {
						echo $args['before_title']. '<a href="'. $instance['link'] .'">' . apply_filters( 'icon_widget_title', $instance['title'] ) . '</a>' . $args['after_title'];
					}

					if ( ! empty( $instance['description'] ) ) {
						echo '<p>'. $instance['description'] .'</p>';
					}
				echo '</div>';

			echo '</div>';

		echo $args['after_widget'];
	}

	/**
	 * Back-end widget form.
	 *
	 * @see WP_Widget::form()
	 *
	 * @param array $instance Previously saved values from database.
	 */
	public function form( $instance ) {
		$title = ! empty( $instance['title'] ) ? $instance['title'] : __( 'Title', 'dhali' );
		$description = ! empty( $instance['description'] ) ? $instance['description'] : __( 'Description', 'dhali' );
		$icon = ! empty( $instance['icon'] ) ? $instance['icon'] : __( 'Icon', 'dhali' );
		$link = ! empty( $instance['link'] ) ? $instance['link'] : __( 'Link', 'dhali' );
		?>
		<p>
		<label for="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>"><?php _e( esc_attr( 'Title:' ) ); ?></label>
		<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'title' ) ); ?>" type="text" value="<?php echo esc_attr( $title ); ?>">
		</p>

		<p>
		<label for="<?php echo esc_attr( $this->get_field_id( 'description' ) ); ?>"><?php _e( esc_attr( 'Description:' ) ); ?></label>
		<textarea class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'description' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'description' ) ); ?>" ><?php echo esc_attr( $description ); ?></textarea>
		</p>

		<p>
		<label for="<?php echo esc_attr( $this->get_field_id( 'icon' ) ); ?>"><?php _e( esc_attr( 'Icon:' ) ); ?></label>
		<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'icon' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'icon' ) ); ?>" type="text" value="<?php echo esc_attr( $icon ); ?>">
		</p>

		<p>
		<label for="<?php echo esc_attr( $this->get_field_id( 'link' ) ); ?>"><?php _e( esc_attr( 'Link:' ) ); ?></label>
		<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'link' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'link' ) ); ?>" type="text" value="<?php echo esc_attr( $link ); ?>">
		</p>
		<?php
	}

	/**
	 * Sanitize widget form values as they are saved.
	 *
	 * @see WP_Widget::update()
	 *
	 * @param array $new_instance Values just sent to be saved.
	 * @param array $old_instance Previously saved values from database.
	 *
	 * @return array Updated safe values to be saved.
	 */
	public function update( $new_instance, $old_instance ) {
		$instance = array();
		$instance['title'] = ( ! empty( $new_instance['title'] ) ) ? strip_tags( $new_instance['title'] ) : '';
		$instance['description'] = ( ! empty( $new_instance['description'] ) ) ? strip_tags( $new_instance['description'] ) : '';
		$instance['icon'] = ( ! empty( $new_instance['icon'] ) ) ? strip_tags( $new_instance['icon'] ) : '';
		$instance['link'] = ( ! empty( $new_instance['link'] ) ) ? strip_tags( $new_instance['link'] ) : '';

		return $instance;
	}

} // class Icon_Widget
add_action( 'widgets_init', function() {	register_widget( 'Icon_Widget' ); } );
