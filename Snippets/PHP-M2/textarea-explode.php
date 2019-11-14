<?php

$lines = explode("\n", $instruction_textarea); // or use PHP PHP_EOL constant
if ( !empty($lines) ) {
  echo '<ul>';
  foreach ( $lines as $line ) {
    echo '<li>'. trim( $line ) .'</li>';
  }
  echo '</ul>';
}
