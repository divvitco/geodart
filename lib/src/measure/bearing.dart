import 'dart:math';

import 'package:geodart/src/featureTypes/point.dart';

/// Computes the [bearing] between two [Point]s.
double bearing(Point from, Point to) {
  final lat1 = from.coordinate.latitude;
  final lon1 = from.coordinate.longitude;
  final lat2 = to.coordinate.latitude;
  final lon2 = to.coordinate.longitude;

  final dLon = lon2 - lon1;
  final y = sin(dLon) * cos(lat2);
  final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
  final bearing = atan2(y, x);

  return bearing;
}
