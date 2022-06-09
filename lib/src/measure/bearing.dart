import 'package:geodart/geometries.dart';

/// Computes the [bearing] between two [Point]s.
/// The bearing is the angle from the north to the second point.
///
/// Example:
/// ```dart
/// bearing(Point(0, 0), Point(0, 1)) // returns 0
/// bearing(Point(0, 0), Point(1, 1)) // returns 45
/// bearing(Point(0, 0), Point(1, 0)) // returns 90
/// ```
double bearing(Point from, Point to) {
  return from.coordinate.bearingTo(to.coordinate);
}
