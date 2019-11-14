<?php
/**
 * Allows .vcf files to be uploaded through Media Library
 */

add_filter('upload_mimes', 'wroten_upload_mimes');
function wroten_upload_mimes ( $existing_mimes=array() ) {
	// add your extension to the array
	$existing_mimes['vcf'] = 'text/x-vcard';
	$existing_mimes['exe'] = 'application/octet-stream';
	return $existing_mimes;
}
