import 'package:geodart/geometries.dart';

/// Computes the [distance] between two [Point]s in meters.
/// The distance is the straight-line distance between the two points.
/// The distance is calculated using the Haversine formula.
///
/// Example:
/// ```dart
/// distance(Point(0, 0), Point(0, 1)) // returns 1
/// distance(Point(0, 0), Point(1, 1)) // returns 1.4142135623730951
/// distance(Point(0, 0), Point(1, 0)) // returns 1
/// ```
double distance(Point from, Point to) {
  return from.coordinate.distanceTo(to.coordinate);
}
