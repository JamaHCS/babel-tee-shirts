function initialize() {
  var myOptions = {
    zoom: 15,
    center: new google.maps.LatLng(20.6539495, -100.4082825), //change the coordinates
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false,
    mapTypeControl: false,
    zoomControl: false,
    streetViewControl: false,
  };

  var img_icon = 'img/map-marker.png';
  var map = new google.maps.Map(
    document.getElementById('map-canvas'),
    myOptions
  );

  var marker = new google.maps.Marker({
    map: map,
    icon: img_icon,
    position: new google.maps.LatLng(20.6539495, -100.4082825), //change the coordinates
  });

  google.maps.event.addListener(marker, 'click', function () {
    infowindow.open(map, marker);
  });
}

google.maps.event.addDomListener(window, 'load', initialize);
