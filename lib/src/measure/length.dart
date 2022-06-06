import 'package:geodart/features.dart';

/// Calculates the [length] of a [LineString] or [MultiLineString], in meters.
double length(Feature line) {
  double getLength(List<Coordinate> coordinates) {
    double length = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      length += coordinates[i].distanceTo(coordinates[i + 1]);
    }
    return length;
  }

  if (line is LineString) {
    return getLength(line.coordinates);
  } else if (line is MultiLineString) {
    return line.coordinates.fold(0.0, (a, b) => a + getLength(b));
  } else {
    throw ArgumentError('Line must be a LineString or MultiLineString');
  }
}
