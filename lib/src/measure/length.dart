import 'package:geodart/features.dart';

/// Calculates the [length] of a [LineString] or [MultiLineString], in meters.
/// Also accessible from [LineString.length] and [MultiLineString.length].
/// The length is calculated using the [Haversine formula]().
/// Compare this snippet from lib/src/measure/length.dart:
///
/// Example:
/// ```dart
/// LineString([Coordinate(1, 2), Coordinate(3, 4)]).length; // 314283.2550736839
/// ```
double length(Feature line) {
  if (line is LineString) {
    return line.length;
  } else if (line is MultiLineString) {
    return line.length;
  } else {
    throw ArgumentError('Line must be a LineString or MultiLineString');
  }
}
