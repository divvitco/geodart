import 'package:geodart/geometries.dart';

void main() {
  var point = Point.fromWKT('POINT(10 20)');
  print(point);
}

void loadFeatureCollectionFromGeojson() {
  var features = FeatureCollection.fromJson({
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [-122.676483, 45.516525]
        },
        "properties": {"name": "Portland"}
      },
      {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [-122.636383, 45.523452]
        },
        "properties": {"name": "Salem"}
      }
    ]
  });
  print('features: ${features.features.length}');

  var point = Point.fromJson({
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [-122.676483, 45.516525]
    },
    "properties": {"name": "Portland"}
  });

  print('point: ${point.coordinate.latitude}');
}

void loadFeaturesFromWkt() {
  var polygon = Polygon.fromWKT(
      'POLYGON((-122.676483 45.516525, -122.636383 45.523452, -122.636383 45.523452, -122.676483 45.516525))');

  var point = Point.fromWKT('POINT(-122.676483 45.516525)');

  print(
      'point: ${point.coordinate.latitude}, polygon: ${polygon.coordinates.length}');
}
