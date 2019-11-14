<?php
/**
 * Export to .csv
 *
 * @link http://php.net/manual/en/function.fputcsv.php
 * @link http://code.stephenmorley.org/php/creating-downloadable-csv-files/
 *
 * @package dhali
 */

// Output headers so that the file is downloaded rather than displayed
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=data.csv');

// Creating Headers array
$headers = array (
	array( 'Column 1', 'Column 2', 'Column 3', 'Column 3' ),
);

// Creating Rows array
$rows = array (
	array( 'aaa', 'bbb', 'ccc', 'ddd' ),
	array( '123', '456', '789', '789' ),
	array( 'aaa', 'bbb', 'ccc', '789' ),
);

// Opens up file to allow write privileges
$file = fopen( 'php://output', 'w' );

// Output the headers to the first row of the file
foreach ( $headers as $header ) {
	fputcsv( $file, $header );
}

// Output the rows
foreach ( $rows as $row ) {
	fputcsv( $file, $row );
}

fclose( $file );