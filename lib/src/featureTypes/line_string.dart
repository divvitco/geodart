import 'package:geodart/features.dart';

/// A [LineString] is a [Feature] made up of connected [Coordinate]s to form a line.
class LineString extends Feature {
  List<Coordinate> coordinates;
  static final String type = 'LineString';

  LineString(this.coordinates, {properties = const {}})
      : super(properties: properties);

  @override
  String toString() {
    return coordinates.map((c) => c.toString()).toList().join(',');
  }

  /// Converts the [LineString] to a [String] in WKT format.
  @override
  String toWKT() {
    return 'LINESTRING(${coordinates.map((c) => c.toWKT()).join(',')})';
  }

  /// Returns a GeoJSON representation of the [LineString]
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'LineString',
        'coordinates': coordinates.map((c) => c.toJson()).toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [LineString] from a valid GeoJSON object
  @override
  factory LineString.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'LineString') {
      throw ArgumentError('json is not a LineString');
    }

    return LineString(
      (json['coordinates'] as List<dynamic>)
          .map((dynamic c) => Coordinate.fromJson(c))
          .toList(),
    );
  }

  /// Creates a [LineString] from a WKT string
  @override
  factory LineString.fromWKT(String wkt) {
    final coordinates = wkt.split('(')[1].split(')')[0].split(',');
    return LineString(
      coordinates.map((c) => Coordinate.fromWKT(c)).toList(),
    );
  }

  /// Explodes the [LineString] into a [List] of [Point]s
  @override
  List<Point> explode() {
    return coordinates.map((e) => Point(e)).toList();
  }
}
