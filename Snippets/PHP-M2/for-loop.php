<?php
/*
 * for loop example
 *
 */

	for ( $x = 0; $x <= 10; $x++ ) {
		echo "The number is: $x <br>";
	}
?>

<?php
/*
 * for loop example with html
 *
 */

  for($x = 1; $x <=3; $x++) : ?>
    <div class="col-sm-4">
      <div class="blog-item">
        <div class="blog-item-image"></div><!-- /.blog-item-image -->
        <div class="blog-item-title">Blog Post Title</div><!-- /.blog-item-title -->
      </div><!-- /.blog-item -->
    </div><!-- /.col -->
<?php endfor; ?>
