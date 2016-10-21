
function intMap() {
	var mapCanvas = document.getElementById('map-canvas');

	// Center
	var center = new google.maps.LatLng(32.850098, -117.2742608);

	var homeLatLng = new google.maps.LatLng(32.850098, -117.2742608);

	// Map Options
	var mapOptions = {
		zoom: 19,
		center: center,
		scrollwheel: false,
		disableDefaultUI: false,
		mapTypeId: google.maps.MapTypeId.SATELLITE,
		styles: [
			{stylers: [{ visibility: 'simplified' }]},
			{elementType: 'labels', stylers: [{ visibility: 'on' }]}
		]
	};

	// Create the Map
	map = new google.maps.Map(mapCanvas, mapOptions);

	// Load FeatureCollection
	var jsonFeatures = featureCollection;
	map.data.addGeoJson(jsonFeatures);

	// Set Style each Feature
	map.data.setStyle(function (feature) {
	    var color = feature.getProperty('fillColor');
	    var opacity = feature.getProperty('fillOpacity');
	    return {
	    	fillColor: color,
	    	strokeWeight: 1,
	    	fillOpacity: opacity
		};
	});

	var markersToRemove = [];



	var marker1 = new MarkerWithLabel({
	       position: homeLatLng,
	       draggable: false,
	       raiseOnDrag: false,
	       map: map,
	       icon: " ",
	       labelContent: "Scripps Park at La Jolla Cove",
	       labelAnchor: new google.maps.Point(22, 0),
	       labelClass: "alert alert-warning", // the CSS class for the label
	       labelStyle: {opacity: 1}
	     });

	markersToRemove.push(marker1);

	AddMarkerWithLabel(map, center, markersToRemove)

	// var marker2 = new MarkerWithLabel({
 //       position: homeLatLng,
 //       draggable: false,
 //       raiseOnDrag: false,
 //       map: map,
 //       icon: " ",
 //       labelContent: "Pacific Ocean",
 //       labelAnchor: new google.maps.Point(200, 100),
 //       labelClass: "alert alert-info", // the CSS class for the label
 //       labelStyle: {opacity: 1}
 //     });

	// markersToRemove.push(marker2);



	// initializing info windo for title and description open on click event
	var infowindow = new google.maps.InfoWindow();

	// adding event listener on click on map
	map.data.addListener('click', function(event) {
		InitializeInfoWindow(map, infowindow, event);
	});
	// -----------------------------------------

};


function AddMarkerWithLabel(map, initialLatLng, arrayOfMarkers){

	var marker = new MarkerWithLabel({
       position: initialLatLng,
       draggable: false,
       raiseOnDrag: false,
       map: map,
       icon: " ",
       labelContent: "The Pacific Ocean",
       labelAnchor: new google.maps.Point(200, 100),
       labelClass: "alert alert-info", // the CSS class for the label
       labelStyle: {opacity: 1}
     });

	arrayOfMarkers.push(marker);

}


function removeMarkers() {
for(var i = 0; i < markersToRemove.length; i++) {
    markersToRemove[i].setMap(null);
	}
}


function InitializeInfoWindow(map, infowindow, event){
	
	var htmlTitle = event.feature.getProperty("title");
	var htmlDesc = event.feature.getProperty("description");

	// Build Title/Desc Div
	var html = BuildHtmlTitle(htmlTitle, htmlDesc);

	infowindow.setContent(html);
	infowindow.setPosition(event.latLng);
	infowindow.setOptions({pixelOffset: new google.maps.Size(0,-30)});
	infowindow.open(map);

}

function BuildHtmlTitle(title, description){
	
	var html;
	html = "<div style='width:150px; text-align: center;'>";
	html += "<strong>" + title + "</strong>"
	html += "<p>" + description + "</p>"
	html += "</div>"

	return html;
}

google.maps.event.addDomListener(window, 'load', intMap);
