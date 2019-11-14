			<ul class="list-footer-nav list-unstyled clearfix">
				<?php
					function dhali_footer_menu(){
						//get all 'first level' pages, then iterate through those results,
						//then for each result, see if there are child pages,
						//and if there are no child pages for that page, then return page ID's
						$pages = get_pages( 'parent=0' );

						$arr = array(); // Create empty array

						foreach ( $pages as $page ) {
							$child = get_pages( 'child_of='.$page->ID );

							if ( empty( $child ) ) {
								array_push( $arr, $page->ID );
							}
						}

						$pageID = implode(',', $arr);
						return $pageID;
					}

					wp_list_pages( array(
						'title_li'		=> '',
						'depth'				=> 2,
						'sort_column'	=> 'post_name',
						'link_before'			=> '<span class="glyphicon glyphicon-play"></span> ',
						'exclude'					=> dhali_footer_menu(),
					));
				?>
			</ul>
