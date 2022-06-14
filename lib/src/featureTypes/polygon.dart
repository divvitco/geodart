import 'dart:math';

import 'package:geodart/geometries.dart';

/// A [Polygon] is a single closed path with shared properties.
/// The first [LinearRing] defines the outer boundary of the [Polygon], while the following [LinearRing]s define holes within the [Polygon].
class Polygon extends Feature {
  List<LinearRing> coordinates;
  static final String type = 'Polygon';

  Polygon(this.coordinates, {properties = const <String, dynamic>{}})
      : super(properties: properties);

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

    List<LinearRing> rings =
        (json['geometry']['coordinates'] as List<List<dynamic>>)
            .map((List<dynamic> shape) => LinearRing(
                shape.map((dynamic c) => Coordinate.fromJson(c)).toList()))
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
  LineString toLineString() {
    return LineString(coordinates.first.coordinates);
  }

  /// The area pf the [Polygon] in square meters.
  double get area {
    num rad(num value) => value * pi / 180;
    double ringArea(LinearRing ring) {
      // ignore: constant_identifier_names
      const WGS84_RADIUS = 6378137;
      double ringAreaSum = 0;

      if (ring.coordinates.length > 2) {
        for (int i = 0; i < coordinates.length; i++) {
          var lowerIndex = i;
          var middleIndex = i + 1;
          var upperIndex = i + 2;

          if (i == ring.coordinates.length - 2) {
            lowerIndex = ring.coordinates.length - 2;
            middleIndex = ring.coordinates.length - 1;
            upperIndex = 0;
          } else if (i == ring.coordinates.length - 1) {
            lowerIndex = ring.coordinates.length - 1;
            middleIndex = 0;
            upperIndex = 1;
          }

          var p1 = ring.coordinates[lowerIndex];
          var p2 = ring.coordinates[middleIndex];
          var p3 = ring.coordinates[upperIndex];

          ringAreaSum +=
              (rad(p3.longitude) - rad(p1.longitude)) * sin(rad(p2.latitude));
        }

        ringAreaSum = ringAreaSum * WGS84_RADIUS * WGS84_RADIUS / 2;
      }

      return ringAreaSum;
    }

    double polygonArea(List<LinearRing> rings) {
      double polyArea = 0;

      if (rings.isNotEmpty) {
        polyArea += ringArea(rings[0]).abs();
        for (var hole in rings.getRange(1, coordinates.length)) {
          polyArea -= ringArea(hole).abs();
        }
      }

      return polyArea;
    }

    return polygonArea(coordinates);
  }
}
