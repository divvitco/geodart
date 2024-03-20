import 'dart:math';

import 'package:geodart/geometries.dart';

/// A [LinearRing] is a closed series of [Coordinate]s. It is used in Polygons and MultiPolygons.
/// Closed means the first and last [Coordinate]s are the same.
class LinearRing {
  final List<Coordinate> coordinates;
  LinearRing(this.coordinates);

  /// Creates a random [LinearRing] with 3 [Coordinate]s.
  ///
  /// Example:
  /// ```dart
  /// LinearRing.random(); // LinearRing([Coordinate(0.0, 0.0), Coordinate(0.0, 0.0), Coordinate(0.0, 0.0)])
  /// ```
  factory LinearRing.random() {
    List<Coordinate> coordinates = [];
    coordinates.add(Coordinate.random());
    coordinates.add(Coordinate.random());
    coordinates.add(Coordinate.random());
    coordinates.add(coordinates[0]);
    return LinearRing(coordinates);
  }

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

  /// Returns the [LinearRing]'s centroid.
  /// The centroid is the [Point] that is the center of the [LinearRing].
  /// Example:
  /// ```dart
  /// LinearRing ring = LinearRing([
  ///   Coordinate(0, 0),
  ///   Coordinate(0, 1),
  ///   Coordinate(1, 1),
  ///   Coordinate(1, 0),
  ///   Coordinate(0, 0),
  /// ]);
  /// print(ring.centroid); // Point(Coordinate(0.5, 0.5))
  /// ```
  Point get centroid {
    double lat = 0;
    double long = 0;

    // Don't want the closing coordinate to count twice
    for (var point in coordinates.sublist(0, coordinates.length - 2)) {
      lat += point.latitude;
      long += point.longitude;
    }

    lat /= (coordinates.length - 1);
    long /= (coordinates.length - 1);

    return Point.fromLatLong(lat, long);
  }

  /// Reverses the [LinearRing]'s [coordinates].
  /// Example:
  /// ```dart
  /// LinearRing ring = LinearRing([
  ///   Coordinate(0, 0),
  ///   Coordinate(0, 1),
  ///   Coordinate(1, 1),
  ///   Coordinate(1, 0),
  ///   Coordinate(0, 0),
  /// ]);
  /// print(ring.coordinates); // [Coordinate(0, 0), Coordinate(0, 1), Coordinate(1, 1), Coordinate(1, 0), Coordinate(0, 0)]
  /// print(ring.reverse().coordinates); // [Coordinate(0, 0), Coordinate(1, 0), Coordinate(1, 1), Coordinate(0, 1), Coordinate(0, 0)]
  /// ```
  LinearRing reverse() {
    return LinearRing(coordinates.reversed.toList());
  }

  /// Returns all the [Coordinate]s of the [LinearRing] as [Point]s.
  ///
  /// Example:
  /// ```dart
  /// LinearRing ring = LinearRing([
  ///   Coordinate(0, 0),
  ///   Coordinate(0, 1),
  ///   Coordinate(1, 1),
  ///   Coordinate(1, 0),
  ///   Coordinate(0, 0),
  /// ]);
  /// print(ring.explode()); // FeatureCollection([Point(Coordinate(0, 0)), Point(Coordinate(0, 1)), Point(Coordinate(1, 1)), Point(Coordinate(1, 0)), Point(Coordinate(0, 0))])
  /// ```
  FeatureCollection explode() {
    List<Point> features = [];
    for (var coordinate in coordinates) {
      features.add(Point(coordinate));
    }
    return FeatureCollection(features);
  }

  /// Returns the [BoundingBox] of the [LinearRing].
  ///
  /// Example:
  /// ```dart
  /// LinearRing ring = LinearRing([
  ///   Coordinate(0, 0),
  ///   Coordinate(0, 1),
  ///   Coordinate(1, 1),
  ///   Coordinate(1, 0),
  ///   Coordinate(0, 0),
  /// ]);
  /// print(ring.bbox); // BoundingBox(0, 0, 1, 1)
  BoundingBox get bbox {
    List<Point> points = explode().features as List<Point>;
    return BoundingBox.fromPoints(points);
  }

  /// Returns whether or not the [LinearRing] contains the [Point].
  /// Uses the [Ray Casting](https://en.wikipedia.org/wiki/Point_in_polygon) algorithm.
  ///
  /// Example:
  /// ```dart
  /// LinearRing ring = LinearRing([
  ///   Coordinate(0, 0),
  ///   Coordinate(0, 1),
  ///   Coordinate(1, 1),
  ///   Coordinate(1, 0),
  ///   Coordinate(0, 0),
  /// ]);
  /// print(ring.contains(Point(Coordinate(0.5, 0.5)))); // true
  /// print(ring.contains(Point(Coordinate(0.5, 1.5)))); // false
  /// ```
  bool contains(Point point) {
    Coordinate testCoord = coordinates.last;
    bool c = false;
    for (Coordinate coord in coordinates) {
      // for each vertex in the polygon,
      if (point.lat == coord.latitude && point.lng == coord.longitude) {
        // the point is a vertex, so return true
        return true;
      } else if (coord.latitude > point.lat != testCoord.latitude > point.lat) {
        // if the point is to the right of the current polygon edge
        double slope = (point.lng - coord.longitude) *
                (testCoord.latitude - coord.latitude) -
            (testCoord.longitude - coord.longitude) *
                (point.lat - coord.latitude);
        if (slope == 0) {
          // if the point is exactly on the current polygon edge
          return true;
        } else if ((slope < 0) != testCoord.latitude < coord.latitude) {
          // if the point is to the right of the current polygon edge
          c = !c;
        }
      }
    testCoord = coord;
    }
    return c;
  }
}
