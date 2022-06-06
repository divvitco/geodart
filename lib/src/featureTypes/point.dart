import 'package:geodart/src/featureTypes/geometries/coordinate.dart';
import 'package:geodart/src/featureTypes/feature.dart';

/// A [Point] is a single position in a coordinate system, with [properties].
class Point extends Feature {
  Coordinate coordinate;
  static final String type = 'Point';

  Point(this.coordinate, {properties = const {}})
      : super(properties: properties);

  @override
  String toString() {
    return '${coordinate.latitude},${coordinate.longitude}';
  }

  /// Converts the [Point] to a WKT [String].
  @override
  String toWKT() {
    return 'POINT(${coordinate.toWKT()})';
  }

  /// Converts the [Point] to a GeoJSON [Map].
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'Point',
        'coordinates': coordinate.toJson(),
      },
      'properties': properties,
    };
  }

  /// Creates a [Point] from a GeoJSON [Map].
  @override
  factory Point.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'Point') {
      throw ArgumentError('json is not a Point');
    }

    return Point(
      Coordinate(json['geometry']['coordinates'][1],
          json['geometry']['coordinates'][0]),
      properties: json['properties'],
    );
  }

  /// Creates a [Point] from a WKT [String].
  @override
  factory Point.fromWKT(String wkt) {
    final coordinates = wkt.split('(')[1].split(')')[0];
    return Point(Coordinate.fromWKT(coordinates));
  }

  /// Creates a [Point] from a Lat/Long pair.
  factory Point.fromLatLong(double latitude, double longitude) {
    return Point(Coordinate(latitude, longitude));
  }
}
