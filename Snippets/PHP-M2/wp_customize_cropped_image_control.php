<?php

	$wp_customize->add_setting('logo_setting');

	$wp_customize->add_control( new WP_Customize_Cropped_Image_Control( $wp_customize, 'logo_setting', array(
			'section'     => 'background_image',
			'label'       => __( 'Logoddd' ),
			'flex_width'  => false, // Allow any width, making the specified value recommended. False by default.
			'flex_height' => false, // Require the resulting image to be exactly as tall as the height attribute (default).
			'width'       => 550,
			'height'      => 100,
	) ) );

$image =  wp_get_attachment_image_src( absint( get_theme_mod( 'logo_setting' ) ), '', false );
echo $image[0];

echo wp_get_attachment_image( absint( get_theme_mod( 'logo_setting' ) ), '', false );

?>
