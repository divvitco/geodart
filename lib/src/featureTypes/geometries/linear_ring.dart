import 'dart:math';

import 'package:geodart/geometries.dart';

/// A [LinearRing] is a closed series of [Coordinate]s. It is used in Polygons and MultiPolygons.
/// Closed means the first and last [Coordinate]s are the same.
class LinearRing {
  List<Coordinate> coordinates;
  LinearRing(this.coordinates);

  /// Converts the [LinearRing] to a [LineString].
  LineString toLineString() {
    return LineString(coordinates);
  }

  /// The area of the [LinearRing] in square meters.
  /// Example:
  /// ```dart
  /// LinearRing ring = LinearRing([
  ///   Coordinate(0, 0),
  ///   Coordinate(0, 1),
  ///   Coordinate(1, 1),
  ///   Coordinate(1, 0),
  ///   Coordinate(0, 0),
  /// ]);
  /// print(ring.area); // 1
  /// ```
  double get area {
    // ignore: constant_identifier_names
    const WGS84_RADIUS = 6378137;
    double ringAreaSum = 0;

    num rad(num value) => value * pi / 180;

    if (coordinates.length > 2) {
      for (int i = 0; i < coordinates.length; i++) {
        var lowerIndex = i;
        var middleIndex = i + 1;
        var upperIndex = i + 2;

        if (i == coordinates.length - 2) {
          lowerIndex = coordinates.length - 2;
          middleIndex = coordinates.length - 1;
          upperIndex = 0;
        } else if (i == coordinates.length - 1) {
          lowerIndex = coordinates.length - 1;
          middleIndex = 0;
          upperIndex = 1;
        }

        var p1 = coordinates[lowerIndex];
        var p2 = coordinates[middleIndex];
        var p3 = coordinates[upperIndex];

        ringAreaSum +=
            (rad(p3.longitude) - rad(p1.longitude)) * sin(rad(p2.latitude));
      }

      ringAreaSum = ringAreaSum * WGS84_RADIUS * WGS84_RADIUS / 2;
    }

    return ringAreaSum;
  }
}
