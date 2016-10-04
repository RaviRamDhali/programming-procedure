$( document ).ready(function() {

	var image = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png';

	$('.marker-add').click(function(e){
		var rnd = Math.floor((Math.random() * 100000) + 1);
		var markerAdd = {title : "Lot #" + rnd,draggable:true,map: "map",lat: 32.84979833387652,lng: -117.27439032142638}

		// Build Google Marker
		objMarker = new google.maps.Marker({
			map: map,
			title : markerAdd.title,
			animation: google.maps.Animation.BOUNCE,
			draggable: markerAdd.draggable,
			position: new google.maps.LatLng(markerAdd.lat, markerAdd.lng),
			icon: image,
			id: rnd
		});


		// objMarker.set("id", rnd);

		console.log(objMarker);
		

		//console.log(val);

	});


});


function intMap() {
	var mapCanvas = document.getElementById('map-canvas');
	
	// Center
	var center = new google.maps.LatLng(32.850098, -117.2742608);

	// Map Options		
	var mapOptions = {
		zoom: 19,
		center: center,
		scrollwheel: false,
		disableDefaultUI: true,
		mapTypeId: google.maps.MapTypeId.SATELLITE,
		styles: [
			{stylers: [{ visibility: 'simplified' }]},
			{elementType: 'labels', stylers: [{ visibility: 'off' }]}
		]
	};
	
	// Create the Map
	map = new google.maps.Map(mapCanvas, mapOptions);

var jsonMarkers = markersSmall;

var jsonFeatures = featureCollection;
map.data.addGeoJson(jsonFeatures);


AddMarkers(map, jsonMarkers);

};

google.maps.event.addDomListener(window, 'load', intMap);

function OutputMarkerToView(event, mark) {
	$('ul.info-box').append('<li class="list-group-item list-group-item-success"><strong>' + mark.title + '</strong> ' + event.latLng + ' [saved]</li>');
}

function AddMarkers(map, jsonMarkers){
	$.each(jsonMarkers, function (key, data) {

		$('ul.info-box').append('<li class="list-group-item"><strong>' + data.title + '</strong> ' + data.lat + " " + data.lng + '</li>');

	    // Build Google Marker
	    objMarker = BuildGoogleMarker(data);
	    objMarker.addListener('dragend', function(e){OutputMarkerToView(e, this);});
	});
};

function BuildGoogleMarker(data){

	// Build Google Marker
	objMarker = new google.maps.Marker({
		map: map,
		title : data.title,
		draggable: data.draggable,
		position: new google.maps.LatLng(data.lat, data.lng)
	});

	return objMarker;
}




	// var marker1 = new Marker({
	// 	title : "Lot #568A",
	// 	draggable:true,
	// 	map: map,
	// 	position: new google.maps.LatLng(32.84979833387652, -117.27439032142638),
	// 	icon: {
	// 		path: SQUARE_PIN,
	// 		fillColor: '#00CCBB',
	// 		fillOpacity: 1,
	// 		strokeColor: '',
	// 		strokeWeight: 0,
	// 		rotation: 75
	// 	},
	// });
	// marker1.addListener('dragend', function(e){placeMarkerAndPanTo(e, this);});
	
	// var marker2 = new Marker({
	// 	title : "Lot #568B",
	// 	draggable:true,
	// 	map: map,
	// 	position: new google.maps.LatLng(32.849817453857604, -117.27467959259036),
	// 	icon: {
	// 		path: SQUARE_PIN,
	// 		fillColor: '#1998F7',
	// 		fillOpacity: 1,
	// 		strokeColor: '',
	// 		strokeWeight: 0
	// 	},
	// 	map_icon_label: '<span class="map-icon map-icon-transit-station"></span>'
	// });
	// marker2.addListener('dragend', function(e){placeMarkerAndPanTo(e, this);});
	
	// var marker3 = new Marker({
	// 	title : "Lot #1155",
	// 	draggable:true,
	// 	map: map,
	// 	position: new google.maps.LatLng(32.85028907875393, -117.27415434589386),
	// 	icon: {
	// 		path: SQUARE,
	// 		fillColor: '#6331AE',
	// 		fillOpacity: 1,
	// 		strokeColor: '',
	// 		strokeWeight: 0
	// 	},
	// 	map_icon_label: '<span class="map-icon map-icon-city-hall"></span>'
	// });
	// marker3.addListener('dragend', function(e){placeMarkerAndPanTo(e, this);});
	
	// var marker4 = new Marker({
	// 	title : "Lot #3589 (closed)",
	// 	draggable:true,
	// 	map: map,
	// 	position: new google.maps.LatLng(32.84992261368003, -117.27404437532425),
	// 	icon: {
	// 		path: SQUARE_ROUNDED,
	// 		fillColor: '#ffff99',
	// 		fillOpacity: .5,
	// 		strokeColor: '#cccc00',
	// 		strokeWeight: 10
	// 	},
	// 	map_icon_label: '<span class="map-icon map-icon-rv-park"></span>'
	// });
	// marker4.addListener('dragend', function(e){placeMarkerAndPanTo(e, this);});


