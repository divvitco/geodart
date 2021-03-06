import 'package:geodart/geometries.dart';

/// A [Point] is a single position in a coordinate system, with [properties].
/// A [Point] can be created from a [Coordinate], from a WKT [String], or from a GeoJSON [Map].
/// A [Point] can be converted to a WKT [String] or GeoJSON [Map].
///
/// Example:
/// ```dart
/// Point(Coordinate(1, 2), {'name': 'point'}); // Point(Coordinate(1, 2), {'name': 'point'})
/// Point(Coordinate(1, 2), {'name': 'point'}).toWKT(); // POINT(1 2)
/// Point(Coordinate(1, 2), {'name': 'point'}).toJson(); // {'type': 'Feature', 'geometry': {'type': 'Point', 'coordinates': [1, 2]}, 'properties': {'name': 'point'}}
/// ```
class Point extends Feature {
  Coordinate coordinate;
  static final String type = 'Point';

  Point(this.coordinate, {properties = const <String, dynamic>{}})
      : super(properties: properties);

  @override
  String toString() {
    return '${coordinate.latitude},${coordinate.longitude}';
  }

  /// Converts the [Point] to a WKT [String].
  ///
  /// Example:
  /// ```dart
  ///    Point(Coordinate(1, 2)).toWKT(); // POINT(1 2)
  /// ```
  @override
  String toWKT() {
    return 'POINT(${coordinate.toWKT()})';
  }

  /// Converts the [Point] to a GeoJSON [Map].
  ///
  /// Example:
  /// ```dart
  ///   Point(Coordinate(1, 2), properties: {'name': 'point'}).toJson();
  /// ```
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
  ///
  /// Example:
  /// ```dart
  /// Point.fromJson({
  ///  'type': 'Feature',
  ///  'geometry': {
  ///    'type': 'Point',
  ///    'coordinates': [1, 2]
  ///   },
  ///   'properties': {'name': 'point'}
  /// });
  /// ```
  @override
  factory Point.fromJson(Map<String, dynamic> json) {
    if (json['geometry'] == null) {
      throw ArgumentError('json does not contain geometry');
    } else if (json['geometry']['type'] != 'Point') {
      throw ArgumentError('json is not a Point');
    } else if (json['geometry']['coordinates'] == null ||
        json['geometry']['coordinates'].isEmpty) {
      throw ArgumentError('json does not contain coordinates');
    }

    return Point(
      Coordinate(json['geometry']['coordinates'][1],
          json['geometry']['coordinates'][0]),
      properties: Map<String, dynamic>.from(json['properties']),
    );
  }

  /// Creates a [Point] from a WKT [String].
  ///
  /// Example:
  /// ```dart
  /// Point.fromWKT('POINT(1 2)');
  /// ```
  @override
  factory Point.fromWKT(String wkt) {
    final coordinates = wkt.split('(')[1].split(')')[0];
    return Point(Coordinate.fromWKT(coordinates));
  }

  /// Creates a [Point] from a Lat/Long pair.
  ///
  /// Example:
  /// ```dart
  /// Point.fromLatLong(1, 2);
  /// ```
  factory Point.fromLatLong(double latitude, double longitude) {
    return Point(Coordinate(latitude, longitude));
  }

  /// Creates a [Point] randomly.
  /// Example:
  /// ```dart
  /// Point.random();
  /// ```
  factory Point.random() {
    return Point(Coordinate.random());
  }

  /// Explodes the [Point] into a list of [Point]s
  /// Pretty useless, but needs to overwrite the [Feature] method.
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2)).explode(); // [Point(1, 2)]
  /// ```
  @override
  List<Point> explode() {
    return [this];
  }

  /// Get the center [Point] of the [Point].
  /// Pretty useless, but needs to overwrite the [Feature] method.
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2)).centroid(); // Point(1, 2)
  /// ```
  @override
  Point get center {
    return this;
  }

  /// Get the latitude of the [Point].
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2)).latitude; // 2
  /// ```
  double get lat {
    return coordinate.latitude;
  }

  /// Get the longitude of the [Point].
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2)).longitude; // 2
  /// ```
  double get lng {
    return coordinate.longitude;
  }

  /// Returns the [BoundingBox] of the [Point]
  /// **Note:** SINGLE POINTS CANNOT BE BOUNDED. WILL ALWAYS RETURN [BoundingBox.empty].
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2)).bbox; // BoundingBox(0, 0, 0, 0)
  /// ```
  @override
  BoundingBox get bbox {
    return BoundingBox.empty();
  }

  /// Returns whether or not the [Point] is contained within the [Polygon] or [MultiPolygon].
  /// Uses the [Ray Casting](https://en.wikipedia.org/wiki/Point_in_polygon) algorithm.
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2)).isContainedBy(Polygon([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])); // false -> Polygon does not have any area, so it cannot contain a point
  /// Point(Coordinate(0.5, 0.5)).isContainedBy(MultiPolygon([Polygon([Coordinate(0, 0), Coordinate(0, 1), Coordinate(1, 1), Coordinate(1, 0), Coordinate(0, 0)])])); // true
  /// ```
  bool isContainedIn(Feature feature) {
    if (feature is Polygon) {
      return feature.contains(this);
    } else if (feature is MultiPolygon) {
      return feature.contains(this);
    } else {
      throw ArgumentError("feature must be a Polygon or MultiPolygon");
    }
  }

  /// Checks for equality between two [Point]s, specifically if they have the same [coordinate] and [properties].
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2), properties: {'name': 'point'}) == Point(Coordinate(1, 2), properties: {'name': 'point'}); // true
  /// Point(Coordinate(1, 2), properties: {'name': 'point'}) == Point(Coordinate(1, 2), properties: {'name': 'point2'}); // false
  /// Point(Coordinate(1, 2), properties: {'name': 'point'}) == Point(Coordinate(1, 3), properties: {'name': 'point'}); // false
  /// ```
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          other.coordinate.longitude == coordinate.longitude &&
          other.coordinate.latitude == coordinate.latitude &&
          other.properties == properties;

  @override
  int get hashCode =>
      coordinate.latitude.hashCode ^
      coordinate.longitude.hashCode ^
      properties.hashCode;
}
