import 'package:geodart/features.dart';

/// Calculates the [length] of a [LineString] or [MultiLineString], in meters.
double length(Feature line) {
  if (line is LineString) {
    return line.length;
  } else if (line is MultiLineString) {
    return line.length;
  } else {
    throw ArgumentError('Line must be a LineString or MultiLineString');
  }
}
