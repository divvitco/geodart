import 'package:geodart/geometries.dart';

/// A [Polygon] is a single closed path with shared properties.
/// The first [LinearRing] defines the outer boundary of the [Polygon], while the following [LinearRing]s define holes within the [Polygon].
class Polygon extends Feature {
  List<LinearRing> coordinates;
  static final String type = 'Polygon';

  Polygon(this.coordinates, {super.properties = const <String, dynamic>{}});

  @override
  String toString() {
    return coordinates
        .map((ring) => ring.coordinates.map((c) => c.toString()).toList())
        .toList()
        .join(',');
  }

  /// Converts the [Polygon] to a WKT [String].
  @override
  String toWKT() {
    return 'POLYGON(${coordinates.map((ring) => "(${ring.coordinates.map((c) => c.toWKT()).toList()})").toList().join(',')})';
  }

  /// Returns a GeoJSON [Map] of the [Polygon].
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'Polygon',
        'coordinates': coordinates
            .map((ring) => ring.coordinates.map((c) => c.toJson()).toList())
            .toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [Polygon] from a GeoJSON [Map].
  @override
  factory Polygon.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'Polygon') {
      throw ArgumentError('json is not a Polygon');
    }

    List<LinearRing> rings = (json['geometry']['coordinates'] as List)
        .map((shape) => LinearRing((shape as List)
            .map((c) => Coordinate.fromJson((c as List)
                .map((e) => (e is int ? e.toDouble() : e as double))
                .toList()))
            .toList()))
        .toList();

    return Polygon(rings,
        properties: Map<String, dynamic>.from(json['properties']));
  }

  /// Creates a [Polygon] from a WKT [String].
  /// **Right now, cannot handle polygons with holes**.
  @override
  factory Polygon.fromWKT(String wkt) {
    final coordinates = wkt.split('(')[1].split(')')[0].split(',');
    return Polygon(
        [LinearRing(coordinates.map((c) => Coordinate.fromWKT(c)).toList())]);
  }

  /// Explodes the [Polygon] into a [List] of [Point]s.
  @override
  List<Point> explode() {
    return coordinates
        .map((ring) => ring.coordinates.map((coord) => Point(coord)))
        .toList()
        .expand((e) => e)
        .toList();
  }

  /// Calculates the center [Point] of the [Polygon].
  /// **Right now, cannot handle polygons with holes**.
  ///
  /// Example:
  /// ```dart
  /// Polygon polygon = Polygon([
  ///   LinearRing([
  ///     Coordinate(0, 0),
  ///     Coordinate(0, 1),
  ///     Coordinate(1, 1),
  ///     Coordinate(1, 0),
  ///     Coordinate(0, 0),
  ///   ]),
  /// ]);
  /// print(polygon.centroid);
  /// ```
  @override
  Point get center {
    List<Point> points = explode();
    double lat = 0;
    double long = 0;

    for (Point point in points) {
      lat += point.coordinate.latitude;
      long += point.coordinate.longitude;
    }
    return Point.fromLatLong(lat / points.length, long / points.length);
  }

  /// Returns the [BoundingBox] of the [Polygon].
  ///
  /// Example:
  /// ```dart
  /// Polygon polygon = Polygon([
  ///   LinearRing([
  ///     Coordinate(0, 0),
  ///     Coordinate(0, 1),
  ///     Coordinate(1, 1),
  ///     Coordinate(1, 0),
  ///     Coordinate(0, 0),
  ///   ]),
  /// ]);
  /// print(polygon.bbox); // [0, 0, 1, 1]
  /// ```
  @override
  BoundingBox get bbox {
    List<Point> points = explode();
    if (points.length < 2) {
      return BoundingBox.empty();
    }
    return BoundingBox.fromPoints(points);
  }

  /// Uses the [Polygon]'s [coordinates] to make a [LineString].
  /// Ignores any holes in the polygon.
  ///
  /// Example:
  /// ```dart
  /// Polygon polygon = Polygon([
  ///   LinearRing([
  ///     Coordinate(0, 0),
  ///     Coordinate(0, 1),
  ///     Coordinate(1, 1),
  ///     Coordinate(1, 0),
  ///     Coordinate(0, 0),
  ///   ]),
  /// ]);
  /// print(polygon.lineString);
  /// ```
  LineString toLineString() {
    return LineString(coordinates.first.coordinates);
  }

  /// The area pf the [Polygon] in square meters.
  ///
  /// Example:
  /// ```dart
  /// Polygon polygon = Polygon([
  ///   LinearRing([
  ///     Coordinate(0, 0),
  ///     Coordinate(0, 1),
  ///     Coordinate(1, 1),
  ///     Coordinate(1, 0),
  ///     Coordinate(0, 0),
  ///   ]),
  /// ]);
  /// print(polygon.area); // 1
  /// ```
  double get area {
    double polyArea = 0;

    polyArea += (coordinates[0].area).abs();
    for (var hole in coordinates.sublist(1)) {
      polyArea -= (hole.area).abs();
    }

    return polyArea;
  }

  /// Returns whether or not the [Polygon] contains the [Point].
  /// Uses the [Ray Casting](https://en.wikipedia.org/wiki/Point_in_polygon) algorithm.
  ///
  /// Example:
  /// ```dart
  /// Polygon polygon = Polygon([
  ///   LinearRing([
  ///     Coordinate(0, 0),
  ///     Coordinate(0, 1),
  ///     Coordinate(1, 1),
  ///     Coordinate(1, 0),
  ///     Coordinate(0, 0),
  ///   ]),
  /// ]);
  /// print(polygon.contains(Point(0.5, 0.5))); // true
  /// ```
  bool contains(Point point) {
    return coordinates.first.contains(point) &&
        !coordinates.sublist(1).any((ring) => ring.contains(point));
  }

  /// Returns whether the two [Polygon]s intersect.
  /// Uses the `toLineString` to check for intersections, rather than checking for shared volume.
  ///
  /// Example:
  /// ```dart
  /// Polygon poly1 = Polygon([
  ///   LinearRing([
  ///     Coordinate(0, 0),
  ///     Coordinate(0, 1),
  ///     Coordinate(1, 1),
  ///     Coordinate(1, 0),
  ///     Coordinate(0, 0),
  ///   ]),
  /// ]);
  /// Polygon poly2 = Polygon([
  ///   LinearRing([
  ///     Coordinate(0.5, 0.5),
  ///     Coordinate(0.5, 1.5),
  ///     Coordinate(1.5, 1.5),
  ///     Coordinate(1.5, 0.5),
  ///     Coordinate(0.5, 0.5),
  ///   ]),
  /// ]);
  /// print(poly1.intersects(poly2)); // true
  /// ```
  bool intersects(Polygon poly) {
    return toLineString()
        .intersections(poly.toLineString())
        .features
        .isNotEmpty;
  }
}
