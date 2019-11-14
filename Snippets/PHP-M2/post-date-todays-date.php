<?php
  // Get Post Date/Todays Date Show Upcoming Event label
  $todays_date = date(get_option( 'date_format' ));
  $event_date = get_the_date();

  if ( strtotime( $event_date ) >= strtotime( $todays_date ) ) {
  	echo '<span class="events-upcoming">Upcoming Event</span>';
} ?>
