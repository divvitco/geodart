import 'dart:math';

import 'package:geodart/src/featureTypes/point.dart';

/// Computes the [distance] between two [Point]s in meters.
double distance(Point from, Point to) {
  final lat1 = from.coordinate.latitude;
  final lon1 = from.coordinate.longitude;
  final lat2 = to.coordinate.latitude;
  final lon2 = to.coordinate.longitude;

  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return 6371 * c;
}
