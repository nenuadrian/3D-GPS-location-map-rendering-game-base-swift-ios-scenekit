function latLonToMeters(lat, lon) {
  var earthRadius = 6378137
  var originShift = (2 * Math.PI * earthRadius / 2)

  var x = (lon * originShift / 180.0)
  var y = (Math.log(Math.tan((90 + lat) * Math.PI / 360)) / (Math.PI / 180))
  y = (y * originShift / 180.0)

  return [x, y]
}

function latLonToTile(lat, lon) {
  var zoom = 16;
  var x = Math.floor(((lon + 180) / 360) * Math.pow(2, zoom));
  var y = Math.floor((1 - Math.log(Math.tan(deg2rad(lat)) + 1 / Math.cos(deg2rad(lat))) / Math.PI) /2 * Math.pow(2, zoom));
  return [x, y]
}

function tileToLatLon(x, y) {
  var n = Math.pow (2, 16)
  var lon_deg = (x / n * 360.0 - 180.0)
  var lat_deg = rad2deg (Math.atan (Math.sinh (Math.PI * (1 - 2 * y / n))))
  return [lat_deg, lon_deg]
}

function rad2deg(angle) {
  return angle * (180.0 / Math.PI)
}

function deg2rad(angle) {
  return (Math.PI / 180) * angle;
}

module.export = {
  
}
