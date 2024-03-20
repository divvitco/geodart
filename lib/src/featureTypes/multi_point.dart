import 'package:geodart/geometries.dart';

/// a [MultiPoint] is a collection of [Coordinate]s that share properties.
class MultiPoint extends Feature {
  List<Coordinate> coordinates;
  static final String type = 'MultiPoint';

  MultiPoint(this.coordinates, {super.properties = const <String, dynamic>{}});

  @override
  String toString() {
    return coordinates.map((c) => c.toString()).toList().join(',');
  }

  /// Converts the [MultiPoint] to a WKT [String].
  ///
  /// Example:
  /// ```dart
  /// MultiPoint([Coordinate(1, 2), Coordinate(3, 4)]).toWKT(); // MULTIPOINT(1 2, 3 4)
  /// ```
  @override
  String toWKT() {
    return 'MULTIPOINT(${coordinates.map((c) => c.toWKT()).join(',')})';
  }

  /// Converts the [MultiPoint] to a GeoJSON [Map].
  ///
  /// Example:
  /// ```dart
  /// MultiPoint([Coordinate(1, 2), Coordinate(3, 4)]).toJson(); // {'type': 'Feature', 'geometry': {'type': 'MultiPoint', 'coordinates': [[1, 2], [3, 4]]}, 'properties': {}}
  /// ```
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiPoint',
        'coordinates': coordinates.map((c) => c.toJson()).toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [MultiPoint] from a valid GeoJSON [Map].
  ///
  /// Example:
  /// ```dart
  /// MultiPoint.fromJson({'type': 'Feature', 'geometry': {'type': 'MultiPoint', 'coordinates': [[1, 2], [3, 4]]}, 'properties': {}}); // MultiPoint([Coordinate(1, 2), Coordinate(3, 4)])
  /// ```
  @override
  factory MultiPoint.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'MultiPoint') {
      throw ArgumentError('json is not a MultiPoint');
    }

    return MultiPoint(
      json['geometry']['coordinates']
          .map((c) => Coordinate(c[1], c[0]))
          .toList(),
      properties: Map<String, dynamic>.from(json['properties']),
    );
  }

  /// Return the center [Point] of the [MultiPoint].
  ///
  /// Example:
  /// ```dart
  /// MultiPoint([Coordinate(1, 2), Coordinate(3, 4)]).center(); // Point(2, 3)
  /// ```
  @override
  Point get center {
    List<Point> points = explode();
    double lat = 0.0;
    double long = 0.0;
    for (var p in points) {
      lat += p.coordinate.latitude;
      long += p.coordinate.longitude;
    }

    return Point.fromLatLong(lat / points.length, long / points.length);
  }

  /// Returns the [BoundingBox] of the [MultiPoint]
  ///
  /// Example:
  /// ```dart
  /// MultiPoint([Coordinate(1, 2), Coordinate(3, 4)]).bbox; // BoundingBox(1, 2, 3, 4)
  /// ```
  @override
  BoundingBox get bbox {
    List<Point> points = explode();
    if (points.length < 2) {
      return BoundingBox.empty();
    }
    return BoundingBox.fromPoints(points);
  }

  /// Creates a [MultiPoint] from a WKT [String].
  ///
  /// Example:
  /// ```dart
  /// MultiPoint.fromWKT('MULTIPOINT(0 0, 1 2)'); // MultiPoint([Coordinate(0, 0), Coordinate(1, 2)])
  /// ```
  @override
  factory MultiPoint.fromWKT(String wkt) {
    final coordinates = wkt.split('(')[1].split(')')[0].split(',');
    return MultiPoint(
      coordinates.map((c) => Coordinate.fromWKT(c)).toList(),
    );
  }

  /// Creates a [MultiPoint] at random.
  /// The number of [Coordinate]s is defined by [points].
  ///
  /// Example:
  /// ```dart
  /// // Create a random MultiPoint with 10 points (not necessarily the points given in the example)
  /// MultiPoint.random(10); // MultiPoint([Coordinate(0, 0), Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(13, 14), Coordinate(15, 16), Coordinate(17, 18)])
  /// ```
  factory MultiPoint.random({int points = 3}) {
    List<Coordinate> coordinates = [];
    for (int i = 0; i < points; i++) {
      coordinates.add(Coordinate.random());
    }
    return MultiPoint(coordinates);
  }

  /// Explodes the [MultiPoint] into a [List] of [Point]s.
  ///
  /// Example:
  /// ```dart
  /// MultiPoint([Coordinate(1, 2), Coordinate(3, 4)]).explode(); // [Point(Coordinate(1, 2)), Point(Coordinate(3, 4))]
  /// ```
  @override
  List<Point> explode() {
    return coordinates.map((c) => Point(c)).toList();
  }

  /// Flattens the [MultiPoint] into a [FeatureCollection] of [Point]s.
  /// Properties of the [MultiPoint] are copied to the [Point]s.
  ///
  /// Example:
  /// ```dart
  /// MultiPoint([Coordinate(1, 2), Coordinate(3, 4)]).flatten(); // FeatureCollection([Point(Coordinate(1, 2)), Point(Coordinate(3, 4))])
  /// ```
  FeatureCollection flatten() {
    return FeatureCollection(
      coordinates.map((c) => Point(c, properties: properties)).toList(),
    );
  }

  /// Returns a [MultiPoint] that is the union of this [MultiPoint] and another [MultiPoint].
  /// The resulting [MultiPoint] will have the same [properties] as this [MultiPoint].
  ///
  /// Example:
  /// ```dart
  /// MultiPoint([Coordinate(1, 2), Coordinate(3, 4)]).union(MultiPoint([Coordinate(2, 3), Coordinate(4, 5)])); // MultiPoint([Coordinate(1, 2), Coordinate(3, 4), Coordinate(2, 3), Coordinate(4, 5)])
  /// ```
  MultiPoint union({MultiPoint? multi, Point? point}) {
    return MultiPoint([
      ...coordinates,
      ...(multi != null ? multi.coordinates : []),
      ...(point != null ? [point.coordinate] : []),
    ], properties: properties);
  }
}
