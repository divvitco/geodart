import 'package:geodart/src/featureTypes/point.dart';

/// Computes the [bearing] between two [Point]s.
double bearing(Point from, Point to) {
  return from.coordinate.bearingTo(to.coordinate);
}
