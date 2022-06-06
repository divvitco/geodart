import 'dart:math';

import 'package:geodart/src/featureTypes/point.dart';

/// Computes the [distance] between two [Point]s in meters.
double distance(Point from, Point to) {
  return from.coordinate.distanceTo(to.coordinate);
}
