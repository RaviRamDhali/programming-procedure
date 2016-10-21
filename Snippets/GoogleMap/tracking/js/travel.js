

var jsonFile = 'points.json';
var bounds = new google.maps.LatLngBounds; // lat-lng bounds
var marker; //marker for the data/lat-lng point
var infowindow; //information window for the data/lat-lng point
var map;

function initialize() {
  var mapOptions = {
    zoom: 3,
    center: new google.maps.LatLng(-180, 0),
    zoomControl: true,
    zoomControlOptions: {
        position: google.maps.ControlPosition.LEFT_TOP
    },
    mapTypeControl: true,
    mapTypeControlOptions: {
        style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
        position: google.maps.ControlPosition.RIGHT_BOTTOM
    },
    scaleControl: true,
    streetViewControl: true,
    streetViewControlOptions: {
        position: google.maps.ControlPosition.LEFT_TOP
    },
    fullscreenControl: true,
    fullscreenControlOptions: {
        position: google.maps.ControlPosition.TOP_RIGHT
    },
  };

  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);

  //render travel location points
  renderTravelLocations();

}

function renderTravelLocations(){
  // load travel points.. the JSON formatted lat-lng file
  $.getJSON( jsonFile, {})
    .done(function(result){beginTravelling(null, result);})
    .fail(function(error){beginTravelling(error);});
}


//show travel points on the map with directional arrows
function beginTravelling(error, jsonPoints) {
  
  if (error != null) {
    alert("Something wrong with the json data file. Please check and try again. Error: " + error);
    return false;
  }
  var travelPoints = jsonPoints.points.coordinates;//parse json into object
  if (travelPoints.length <= 0) {
    alert('JSON file does not have any lat-lng locations to show on route. Please check the file and try again.');
    return false;
  }

  var travelPlaces = [];
  infowindow = new google.maps.InfoWindow();
  
  var startPoint= 0;
  var i = 0;
  var endPoint = travelPoints.length - 1;
  var routeLength = 0;
  var travelTime;
  travelPoints.forEach(function(place){
    //console.log(place);
    var position = new google.maps.LatLng(place[1], place[0]);

    //randor
    travelPlaces.push(position);
    bounds.extend(position);

    if (i > 0) {
      routeLength += google.maps.geometry.spherical.computeDistanceBetween(travelPlaces[i], travelPlaces[i-1]); 
      if (i == endPoint) {
        travelTime = timeDifference(travelPoints[endPoint][2], travelPoints[0][2]);
      }
    }

    if (i == startPoint || endPoint == i) {
      if (i == endPoint) {
        routeLength = Math.round(routeLength / 1000 * 0.6214 *10)/10;
        linkMarker(place, position, i, routeLength, travelTime);
        var routeInfo = '<strong>Route Info: </strong><br><strong>Distnace Traveled: </strong>' + routeLength + ' mile(s)<br><strong>Travel Time: </strong> '+ travelTime;
        $('#route-info').html(routeInfo).removeClass('disable').addClass('enable');
      }else{
        linkMarker(place, position, i, null, null);
      }
    }else{
      linkMarker(place, position, null, null, null);
    }

    i++;


  });

  //icon setting for directional arrows --> pointing in forward directional
  var iconsetngs = {
      path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
      strokeColor: 'green',
      strokeOpacity: 0.9,
      strokeWeight: 2,
      scale: 3.5,
      fillColor: 'green',
      fillOpacity: 1,
  };

  var travelWay = new google.maps.Polyline({
      path: travelPlaces,
      geodesic: true,
      fillColor: '#fed89d',
      strokeColor: '#f79c22',
      strokeOpacity: 0.9,
      strokeWeight: 6,
      icons: [{
          icon: iconsetngs,
          repeat:'45px',
          offset: '100%'}]
  });

  // //draw the way on the map
  travelWay.setMap(map);

  //fit the travel route in visible bound/region of the map
  map.fitBounds(bounds);
}

//link marker to the location point
/*
@place for informational purpose
@position for marker
@i for start and end point  
*/
function linkMarker(place, position, i, routeLength, travelTime) {
  // create marker for the location point
    var customFC = '#000';
    var customFO = 0.9; //customized fill opacity for points except start and end
    var customScale = 5; //customized scale..
    var customSW = 1.5; //customized stroke weight..

    if (i !== null) {
      customFC = 'green';
      customFO = 0.9;
      customScale = 7;
      customSW = 2;
    }

    var circle ={
        path: google.maps.SymbolPath.CIRCLE,
        fillColor: customFC,
        fillOpacity: customFO,
        scale: customScale,
        strokeColor: '#FFF',
        strokeWeight: customSW,
    };


    var marker = new google.maps.Marker({
      position: position,
      icon: circle,
      title: 'some title goes here!',
    });

    marker.setMap(map);
    
    // add action events so the info windows will be shown when the marker is clicked
    google.maps.event.addListener(marker, 'click', function() {

      if (routeLength !== null && travelTime !== null) {
        //content for the information window
        var locationInfo = '<div class="location-info"><h4>Travel Point</h4><div><strong>Lat: </strong>' + place[1] + '</div><div><strong>Lng: </strong>' + place[0] + '<br><strong>Time: </strong>' + place[2] + '<br><strong>Distnace Traveled: </strong>' + routeLength + ' mile(s)<br><strong>Travel Time: </strong> '+ travelTime +'</div></div>';
      }else{
        //content for the information window
        var locationInfo = '<div class="location-info"><h4>Travel Point</h4><div><strong>Lat: </strong>' + place[1] + '</div><div><strong>Lng: </strong>' + place[0] + '<br><strong>Time: </strong>' + place[2] + '</div></div>';
      }

      infowindow.close(); //close open window if any
      infowindow.setContent(locationInfo); //set the content
      infowindow.open(map, marker);
    });
    
}

//use this if want to integrate geolocation
function myLocation(){
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = new google.maps.LatLng(position.coords.latitude,
                                       position.coords.longitude);

      var infowindow = new google.maps.InfoWindow({
        map: map,
        position: pos,
        content: 'Location found using HTML5.'
      });
      
      marker = new google.maps.Marker({
          map: map, 
          position: pos,
            icon: 'http://priyaminstitute.com/images/ICON_location.gif'
      });

      map.setCenter(pos);
    }, function() {
      handleNoGeolocation(true);
    });
  } else {
    // Browser doesn't support Geolocation
    handleNoGeolocation(false);
  }
}
// handle if geolocation is disabled or blocked by user
function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }
  alert(content);
  return;

  var options = {
    map: map,
    position: new google.maps.LatLng(60, 105),
    content: content
  };

  var infowindow = new google.maps.InfoWindow(options);
  map.setCenter(options.position);
}


//calculate time difference
function timeDifference(date1,date2) {
  console.log(date1);
  date1 = new Date(date1);
  date2 = new Date(date2);
  console.log(date1);
  var difference = date1.getTime() - date2.getTime();

  var daysDifference = Math.floor(difference/1000/60/60/24);
  difference -= daysDifference*1000*60*60*24

  var hoursDifference = Math.floor(difference/1000/60/60);
  difference -= hoursDifference*1000*60*60

  var minutesDifference = Math.floor(difference/1000/60);
  difference -= minutesDifference*1000*60

  var secondsDifference = Math.floor(difference/1000);

  var returnDifference = "";
  if (daysDifference !== null && daysDifference > 0) {
    returnDifference += daysDifference + ' day(s) ';
  }
  if (hoursDifference !== null && hoursDifference > 0) {
    returnDifference += hoursDifference + ' hour(s) ';
  }
  if (minutesDifference !== null && minutesDifference > 0) {
    returnDifference += minutesDifference + ' minute(s) ';
  }
  if (secondsDifference !== null && secondsDifference > 0) {
    returnDifference += secondsDifference + ' second(s) ';
  }
  return returnDifference;
}
google.maps.event.addDomListener(window, 'load', initialize);
