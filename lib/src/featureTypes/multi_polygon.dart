import 'package:geodart/geometries.dart';

/// A [MultiPolygon] is a collection of [Polygon] Geometries with shared properties.
class MultiPolygon extends Feature {
  List<List<LinearRing>> coordinates;
  static final String type = 'MultiPolygon';

  MultiPolygon(this.coordinates,
      {super.properties = const <String, dynamic>{}});

  @override
  String toString() {
    return coordinates.map((poly) => poly.toString()).toList().join(',');
  }

  /// Converts the [MultiPolygon] to a WKT [String].
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [
  ///     LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
  ///   ],
  ///   [
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ]
  /// ]).toWKT(); // MULTIPOLYGON(((1 2, 3 4, 5 6, 1 2)), ((7 8, 9 10, 11 12, 7 8)))
  /// ```
  @override
  String toWKT() {
    return 'MULTIPOLYGON (${coordinates.map((poly) => "(${poly.map((ring) => "(${ring.coordinates.map((c) => c.toWKT()).toList().join(', ')})").toList().join(', ')})").join(', ')})';
  }

  /// Returns a GeoJSON representation of the [MultiPolygon]
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [
  ///     LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
  ///   ],
  ///   [
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ]
  /// ]).toJson(); // {'type': 'Feature', 'geometry': {'type': 'MultiPolygon', 'coordinates': [[[[1, 2], [3, 4], [5, 6], [1, 2]]], [[[7, 8], [9, 10], [11, 12], [7, 8]]]]}, 'properties': {}}
  /// ```
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiPolygon',
        'coordinates': coordinates
            .map((poly) =>
                poly.map((ring) => ring.coordinates.map((c) => c.toJson())))
            .toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [MultiPolygon] from a GeoJSON [Map].
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon.fromJson({'type': 'Feature', 'geometry': {'type': 'MultiPolygon', 'coordinates': [[[[1, 2], [3, 4], [5, 6], [1, 2]]], [[[7, 8], [9, 10], [11, 12], [7, 8]]]]}, 'properties': {}}); // MultiPolygon([[LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)]), LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])]])
  /// ```
  @override
  factory MultiPolygon.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'MultiPolygon') {
      throw ArgumentError('json is not a MultiPolygon');
    }

    MultiPolygon poly = MultiPolygon(
      (json['geometry']['coordinates'] as List)
          .map((poly) => (poly as List)
              .map((shape) => LinearRing((shape as List)
                  .map((coord) => Coordinate.fromJson((coord as List)
                      .map((e) => (e is int ? e.toDouble() : e as double))
                      .toList()))
                  .toList()))
              .toList()) // Convert the outer Iterable to a List
          .toList(), // Convert the inner Iterable to a List
      properties: Map<String, dynamic>.from(json['properties']),
    );

    return poly;
  }

  /// Creates a [MultiPolygon] from a WKT [String].
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon.fromWKT('MULTIPOLYGON(((1 2, 3 4, 5 6, 1 2)), ((7 8, 9 10, 11 12, 7 8)))'); // MultiPolygon([[LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)]), LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])]])
  /// ```
  @override
  factory MultiPolygon.fromWKT(String wkt) {
    final polygonType = wkt.startsWith('MULTIPOLYGON');
    if (!polygonType) {
      throw ArgumentError('wkt is not a MultiPolygon');
    }
    final parens = wkt.split('MULTIPOLYGON')[1].trim();
    final trimmed = parens.substring(
        3, parens.length - 3); // remove MULTIPOLYGON and surrounding brackets
    final polygons =
        trimmed.split(RegExp(r'\)\),\s*\(\(')); // split by )), (( or )),((
    return MultiPolygon(polygons
        .map((poly) => Polygon.fromWKT('POLYGON(($poly))').coordinates)
        .toList());
  }

  /// explode the [MultiPolygon] into a [List] of [Point]s.
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [
  ///     LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
  ///   ],
  ///   [
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ]
  /// ]).explode(); // [Point(1, 2), Point(3, 4), Point(5, 6), Point(1, 2), Point(7, 8), Point(9, 10), Point(11, 12), Point(7, 8)]
  /// ```
  @override
  List<Point> explode() {
    final explodedFeatures = <Point>[];
    for (final poly in coordinates) {
      explodedFeatures.addAll(poly
          .map((ring) => ring.coordinates.map((cord) => Point(cord)).toList())
          .toList()
          .expand((i) => i)
          .toList());
    }
    return explodedFeatures;
  }

  @override
  Point get center {
    List<Point> points = explode();
    double lat = 0;
    double long = 0;
    for (final point in points) {
      lat += point.coordinate.latitude;
      long += point.coordinate.longitude;
    }

    return Point.fromLatLong(lat / points.length, long / points.length);
  }

  /// Returns the [BoundingBox] of the [MultiPolygon].
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [
  ///     LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
  ///   ],
  ///   [
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ]
  /// ]).bbox; // BoundingBox(2, 1, 12, 11)
  /// ```
  @override
  BoundingBox get bbox {
    List<Point> points = explode();
    if (points.length < 2) {
      return BoundingBox.empty();
    }
    return BoundingBox.fromPoints(points);
  }

  /// Converts the [MultiPolygon] to a WKT a [MultiLineString].
  /// Uses the outer ring of each polygon, all holes are ignored.
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [
  ///     LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
  ///   ],
  ///   [
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ]
  /// ]).toMultiLineString(); // MultiLineString([[Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)], [Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)]])
  MultiLineString toMultiLineString() {
    return MultiLineString(
        coordinates.map((poly) => poly.first.coordinates).toList());
  }

  /// Breaks the [MultiPolygon] into a [FeatureCollection] containing each [Polygon]s.
  /// Also, copies the [properties] of the [MultiPolygon] to each [Polygon].
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [
  ///     LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
  ///   ],
  ///   [
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ]
  /// ]).flatten(); // FeatureCollection([Polygon([LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])]),Polygon([LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])])])
  /// ```
  FeatureCollection flatten() {
    return FeatureCollection(coordinates
        .map((poly) => Polygon(poly, properties: properties))
        .toList());
  }

  /// Returns a [MultiPolygon] that is the union of this [MultiPolygon] and another [MultiPolygon] or [Polygon].
  /// The resulting [MultiPolygon] will have the same [properties] as this [MultiPolygon].
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([[LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])]]).union(multi: MultiPolygon([[LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])]])); // MultiPolygon([[LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])], [LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])]])
  /// ```
  MultiPolygon union({MultiPolygon? multi, Polygon? poly}) {
    if (poly == null && multi == null) {
      throw ArgumentError('multi or poly must be provided');
    }
    return MultiPolygon([
      ...coordinates,
      ...(multi != null ? multi.coordinates : []),
      ...(poly != null ? [poly.coordinates] : []),
    ], properties: properties);
  }

  /// The area of the [MultiPolygon] in square meters.
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([[LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])]]).area; // 0.0
  /// ```
  double get area {
    return coordinates.fold(
        0.0, (double acc, poly) => acc + Polygon(poly).area);
  }

  /// Returns whether or not the [Point] is contained within the [MultiPolygon].
  /// This is done by checking if the [Point] is contained within any of the [Polygon]s.
  /// Uses the [Ray Casting](https://en.wikipedia.org/wiki/Point_in_polygon) algorithm.
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([[LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])]]).contains(Point(2, 2)); // true
  /// ```
  bool contains(Point point) {
    return coordinates.any((poly) => Polygon(poly).contains(point));
  }

  /// Returns whether or not the [MultiPolygon] overlaps itself.
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [
  ///     LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
  ///   ],
  ///   [
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ]
  /// ]).hasSelfIntersections; // false
  bool get hasSelfIntersections {
    for (int i = 0; i < coordinates.length; i++) {
      for (int j = i + 1; j < coordinates.length; j++) {
        if (Polygon(coordinates[i]).intersects(Polygon(coordinates[j]))) {
          return true;
        }
      }
    }
    return false;
  }

  /// Returns whether or not the [MultiPolygon] intersects another [MultiPolygon] or [Polygon].
  ///
  /// Example:
  /// ```dart
  /// MultiPolygon([
  ///   [LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])]
  /// ]).intersects(
  ///   poly: Polygon([
  ///     LinearRing([Coordinate(7, 8), Coordinate(9, 10), Coordinate(11, 12), Coordinate(7, 8)])
  ///   ])
  /// ); // false
  /// ```
  bool intersects({MultiPolygon? multi, Polygon? poly}) {
    if (multi != null) {
      for (final ringSets in multi.coordinates) {
        if (intersects(poly: Polygon(ringSets))) {
          return true;
        }
      }
      return false;
    } else if (poly != null) {
      for (final ringSets in coordinates) {
        if (Polygon(ringSets).intersects(poly)) {
          return true;
        }
      }
      return false;
    } else {
      throw ArgumentError('multi or poly must be provided');
    }
  }
}
